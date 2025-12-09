import multiprocessing as mp
import time
from functools import partial

from bes_rules import N_CPU
import logging

logger = logging.getLogger(__name__)


def func_kwargs_wrapper(arg: tuple):
    """Wrapper to enable the use of standard
    kwargs in the function to be evaluated."""
    func, kwargs = arg
    return func(**kwargs)


def execute_function_in_parallel(
        func: callable,
        func_kwargs: list,
        n_cpu: int = N_CPU,
        use_mp: bool = True,
        notifier: callable = None,
        percentage_when_to_message: int = 10,
        memory_per_process_gb: float = None
):
    """
    Executes a given function in parallel using multiprocessing or in a single process.

    This function will execute the specified callable `func` for each set of keyword
    arguments in `func_kwargs`. It can utilize multiple CPU cores if `n_cpu > 1` and
    `use_mp` is True. Otherwise, it runs in a single process.

    Args:
        func (callable):
            The function to execute.
        func_kwargs (list):
            A list of dictionaries, each containing keyword arguments for `func`.
        n_cpu (int, optional):
            Number of CPU cores to use for parallel execution. Defaults to N_CPU.
        use_mp (bool, optional):
            Whether to use multiprocessing. Defaults to True.
        notifier (callable, optional):
            A callable to provide progress updates. Defaults to logger.info.
        percentage_when_to_message (int, optional):
            The percentage of completion at which to send progress notifications. Defaults to 10.
        memory_per_process_gb (float):
            Maximal expected GB usage per process

    Returns:
        list: A list of return values from each function execution.
    """
    if notifier is None:
        notifier = logger.info
    idx = 0
    all_returns = []
    n_calls = len(func_kwargs)
    wrapper_inputs = [(func, kwargs) for kwargs in func_kwargs]
    # Take current time
    start_time = time.time()
    last_start_time = start_time
    notify_kwargs = dict(
        function_name=func.__name__,
        n_calls=n_calls,
        notifier=notifier,
        percentage_when_to_message=percentage_when_to_message
    )
    if n_cpu > 1 and use_mp:
        pool = mp.Pool(processes=n_cpu)
        if memory_per_process_gb is not None:
            semaphore = get_memory_semaphore(memory_per_process_gb=memory_per_process_gb)
            func_kwargs_wrapper_to_use = partial(func_kwargs_wrapper_semaphore, semaphore=semaphore)
        else:
            func_kwargs_wrapper_to_use = func_kwargs_wrapper

        for return_ in pool.imap(func_kwargs_wrapper_to_use, wrapper_inputs):
            idx += 1
            all_returns.append(return_)
            last_start_time = _possibly_notify(
                idx=idx,
                start_time=last_start_time,
                **notify_kwargs
            )
        pool.close()
        pool.join()
        return all_returns
    # Else use single process
    for kwargs in func_kwargs:
        return_ = func(**kwargs)
        all_returns.append(return_)
        idx += 1
        last_start_time = _possibly_notify(
            idx=idx,
            start_time=last_start_time,
            **notify_kwargs
        )
    return all_returns


def _possibly_notify(
        start_time: float,
        idx: int,
        n_calls: int,
        function_name: str,
        notifier: callable,
        percentage_when_to_message: int,
):
    """
    Args:
        percentage_when_to_message (int):
            Each time this percentage of inputs was executed a message is
            sent to notifier to inform about the process
        notifier (callable):
            Callable to tell how the execution is going, default logger.info
    """
    percentage_finished = idx / n_calls * 100
    last_percentage_finished = (idx - 1) / n_calls * 100
    if int(last_percentage_finished/percentage_when_to_message) >= int(percentage_finished/percentage_when_to_message):
        return start_time  # No increased by percentage_when_to_message
    time_elapsed = round((time.time() - start_time) / 60, 2)  # In minutes
    approx_time_to_finish = (100 - percentage_finished) * time_elapsed / percentage_when_to_message
    if approx_time_to_finish > 60 or time_elapsed > 60:
        unit = "h"
        approx_time_to_finish /= 60
        time_elapsed /= 60
    else:
        unit = "min"
    message = f"Executed {idx} of {n_calls} inputs to function {function_name}. " \
              f"Took {time_elapsed} {unit}. " \
              f"Until finished approximately {max(0.0, approx_time_to_finish)} {unit}."
    notifier(message)
    # Update current time
    return time.time()


def get_worker_idx():
    """Index of the current worker"""
    _id = mp.current_process()._identity
    if _id:
        return _id[0]
    return None


def get_memory_semaphore(memory_per_process_gb: float = 1) -> mp.Semaphore:
    """
    Create a semaphore based on available memory

    Args:
        memory_per_process_gb (float): Maximal expected GB usage per process
    """
    available_memory_gb = get_available_ram()
    if available_memory_gb is None:
        return mp.Semaphore(100)
    max_processes = int(available_memory_gb / memory_per_process_gb)
    return mp.Manager().Semaphore(max_processes)


def get_available_ram():
    try:
        import psutil
    except ImportError:
        logger.error("psutil not installed, can't check available RAM, returning inf semaphore.")
        return None
    return psutil.virtual_memory().available / (1024**3)


def func_kwargs_wrapper_semaphore(arg: tuple, semaphore: mp.Semaphore):
    """
    Wrapper to enable the use of standard
    kwargs in the function to be evaluated, adding a semaphore
    to prevent MemoryErrors
    """
    with semaphore:
        return func_kwargs_wrapper(arg)
