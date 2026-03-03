
var s = (_cylinderRadius * 2)/100;

_cylinder.Draw(0, 0, 0, s, s, _cylinderHeight / 100);

s = s + 0.3;//25;

_cylinder.Draw(0, 0, _cylinderHeight / 2 + 25, s, s, 0.5);

_cylinder.Draw(0, 0, -_cylinderHeight / 2 - 25, s, s, 0.5);


_drawSpheres();

