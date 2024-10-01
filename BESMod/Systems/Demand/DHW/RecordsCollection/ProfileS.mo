within BESMod.Systems.Demand.DHW.RecordsCollection;
record ProfileS "Profile S"
  extends BESMod.Systems.Demand.DHW.RecordsCollection.PartialDHWTap(
    QCrit=0.945,
    tCrit=3600,
    table=[0,0,0,10,10; 25200,0,0,10,10; 25200,0.105,0.05,25,25; 25321,0,0.05,
        10,10; 25321,0,0,10,10; 27000,0,0,10,10; 27000,0.105,0.05,25,25; 27121,
        0,0.05,10,10; 27121,0,0,10,10; 30600,0,0,10,10; 30600,0.105,0.05,25,25;
        30721,0,0.05,10,10; 30721,0,0,10,10; 34200,0,0,10,10; 34200,0.105,0.05,
        25,25; 34321,0,0.05,10,10; 34321,0,0,10,10; 41400,0,0,10,10; 41400,
        0.105,0.05,25,25; 41521,0,0.05,10,10; 41521,0,0,10,10; 42300,0,0,10,10;
        42300,0.105,0.05,25,25; 42421,0,0.05,10,10; 42421,0,0,10,10; 45900,0,0,
        10,10; 45900,0.315,0.066666667,55,55; 45990,0,0.066666667,10,10; 45990,
        0,0,10,10; 64800,0,0,10,10; 64800,0.105,0.05,25,25; 64921,0,0.05,10,10;
        64921,0,0,10,10; 65700,0,0,10,10; 65700,0.105,0.05,40,40; 65760,0,0.05,
        10,10; 65760,0,0,10,10; 73800,0,0,10,10; 73800,0.42,0.066666667,55,55;
        73921,0,0.066666667,10,10; 73921,0,0,10,10; 77400,0,0,10,10; 77400,
        0.525,0.083333333,45,45; 77555,0,0.083333333,10,10; 77555,0,0,10,10;
        86400,0,0,10,10],
    VDHWDay=43.5e-3);

end ProfileS;