within BESMod.Examples.UseCaseModelicaConferencePaper;
model ModelWithErrorBoth
  extends TEASERBuilding(
    use_busForTSet=true,
    use_minMax=false,
    use_bypass=true);
end ModelWithErrorBoth;
