within BESMod.Systems.Hydraulical.Components.Frosting;
package Functions

  function CICOBasedFunction
    "Function to calculate the growth rate according to CICO (Liang et al. 2019) and defrost time according to Zhu, 2015."
    extends partialFrostingMap;

  protected
    Modelica.Units.SI.TemperatureDifference dT = 1.7e3 * CICO ^ (-0.36);
    Modelica.Units.SI.Temperature T_c = T_oda - dT;
  algorithm
    growth_rate :=  (-3e-7 * log(CICO) + 5.4e-6);
    critDefTim := 0;
    // Mapping of CICO into the map by Zhu to determine the time until defrost
    if CICO <= 18e6 then
      critDefTim := 30 * 60;
    elseif CICO <= 39e6 then
      critDefTim := 60 * 60;
    elseif CICO <= 61e6 then
      critDefTim := 165 * 60;
    else
      critDefTim := Modelica.Constants.inf;
    end if;
    if T_oda >= 279.15 then
      growth_rate := 0;
      critDefTim := Modelica.Constants.inf;
    end if;
    Char :={critDefTim,growth_rate};

  end CICOBasedFunction;

  function ZhuFrostingMapCico
    "Function to calculate the growth rate according to Liang et al. 2020 and defrost time according to Zhu, 2015."
    extends partialFrostingMap;

  protected
    parameter Real coeff_severe[4] = {8.24762543e-01, -1.90727602e-02, 1.19709272e-03, 2.15230362e-05};
    parameter Real coeff_moderate[4] = {5.81825389e-01, -8.80317871e-03, 6.18167285e-04, -7.75483854e-07};
    parameter Real coeff_mild[4] = {4.42929753e-01, -7.03658239e-03, 7.32505699e-05, -3.37264259e-06};
    Real relHum_severe = poly_fit(coeff_severe, T_oda-273.15);
    Real relHum_moderate = poly_fit(coeff_moderate, T_oda-273.15);
    Real relHum_mild = poly_fit(coeff_mild, T_oda-273.15);
    function poly_fit
      input Real coeff[4];
      input Real x;
      output Real y;
    algorithm
      y := 0;
      for n in 1:size(coeff, 1) loop
        y := y + coeff[n] * x^(n - 1);
      end for;
    end poly_fit;
  algorithm
    if relHum >= relHum_severe then
      growth_rate := 3.6e-7;
      critDefTim := 30 * 60;
    elseif relHum >= relHum_moderate then
      growth_rate := 2.5e-7;
      critDefTim := 60 * 60;
    elseif relHum >= relHum_mild then
      growth_rate := 0.7e-7;
      critDefTim := 165 * 60;
    else
      growth_rate := 0;
      critDefTim := Modelica.Constants.inf;
    end if;
    if T_oda >= 279.15 then
      growth_rate := 0;
      critDefTim := Modelica.Constants.inf;
    end if;
    Char :={critDefTim,growth_rate};

  end ZhuFrostingMapCico;

  partial function partialFrostingMap "Function for a partial frost map"
    input Modelica.Units.SI.Temperature T_oda "Outdoor air temperature";
    input Real relHum "Relative humidity as float (betwenn 0 and 1)";
    input Real CICO(unit="s/m") "CICO  value";
    output Real Char[2] "Array with: critDefTim (Time until next defrost cycle) and growth_rate(Growth rate of ice on the surface)";
  protected
    Modelica.Units.SI.Velocity growth_rate(min=0) "Growth rate of ice";
    Modelica.Units.SI.Time critDefTim "Time until next defrost cycle (based on time-method)";

  end partialFrostingMap;

end Functions;
