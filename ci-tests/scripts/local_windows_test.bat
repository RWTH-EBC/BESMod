:: Make sure you have everything installed as in the util scripts:
:: .activate_python_and_install_requirements
:: .custom_install_additional_modelica_libraries
:: .github_ssh_auth


python -m ModelicaPyCI.syntax.html_tidy --filter-whitelist-flag  --correct-view-flag  --log-flag  --whitelist-library IBPSA --library BESMod --packages Examples Tutorial Utilities Systems 
python -m ModelicaPyCI.syntax.html_tidy --filter-whitelist-flag  --correct-view-flag  --log-flag  --whitelist-library IBPSA --library BESMod --packages Examples Tutorial Utilities Systems 

python -m ModelicaPyCI.syntax.style_checking --startup-mos startup.mos --dymola-version 2022 --library BESMod 
python -m ModelicaPyCI.syntax.style_checking --changed-flag  --startup-mos startup.mos --dymola-version 2022 --library BESMod 

python -m ModelicaPyCI.syntax.naming_guideline --changed-flag  --main-branch main --config ci-tests/naming_guideline.toml --library BESMod 

:: Check & Simulate BESMod Examples on PR
python -m ModelicaPyCI.unittest.validatetest --dym-options DYM_SIM DYM_CHECK --startup-mos startup.mos --dymola-version 2022 --additional-libraries-to-load  --library BESMod  --packages Examples
:: Check & Simulate BESMod Examples on push
python -m ModelicaPyCI.unittest.validatetest --dym-options DYM_SIM DYM_CHECK --changed-flag  --startup-mos startup.mos --dymola-version 2022 --additional-libraries-to-load  --library BESMod  --packages Examples
:: Check & Simulate BESMod Tutorial on PR
python -m ModelicaPyCI.unittest.validatetest --dym-options DYM_SIM DYM_CHECK --startup-mos startup.mos --dymola-version 2022 --additional-libraries-to-load  --library BESMod  --packages Tutorial
:: Check & Simulate BESMod Tutorial on push
python -m ModelicaPyCI.unittest.validatetest --dym-options DYM_SIM DYM_CHECK --changed-flag  --startup-mos startup.mos --dymola-version 2022 --additional-libraries-to-load  --library BESMod  --packages Tutorial
:: Check & Simulate BESMod Utilities on PR
python -m ModelicaPyCI.unittest.validatetest --dym-options DYM_SIM DYM_CHECK --startup-mos startup.mos --dymola-version 2022 --additional-libraries-to-load  --library BESMod  --packages Utilities
:: Check & Simulate BESMod Utilities on push
python -m ModelicaPyCI.unittest.validatetest --dym-options DYM_SIM DYM_CHECK --changed-flag  --startup-mos startup.mos --dymola-version 2022 --additional-libraries-to-load  --library BESMod  --packages Utilities
:: Check & Simulate BESMod Systems on PR
python -m ModelicaPyCI.unittest.validatetest --dym-options DYM_SIM DYM_CHECK --startup-mos startup.mos --dymola-version 2022 --additional-libraries-to-load  --library BESMod  --packages Systems
:: Check & Simulate BESMod Systems on push
python -m ModelicaPyCI.unittest.validatetest --dym-options DYM_SIM DYM_CHECK --changed-flag  --startup-mos startup.mos --dymola-version 2022 --additional-libraries-to-load  --library BESMod  --packages Systems
