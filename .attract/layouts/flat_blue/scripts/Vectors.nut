/*

FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End

graphic design by: www.ClanLogoDesign.com
layout scripting by: Chris Van Graas
shader code by: Timothy Lottes, LUKE NUKEM, krischan, Chris Van Graas

Simple implementation of scalar and vector data types.

Each type includes multiple names for accessing member properties:

scalar2 and vec2 properties:
    x|posx|w|width
    y|posy|h|height

scalar3 and vec3 properties:
    x|posx|r|red
    y|posy|g|green
    z|posz|b|blue

scalar4 and vec4 properties:
    x|posx|r|red
    y|posy|g|green
    z|posz|b|blue|width
    w|scale|a|alpha|height

*/

class scalar2
{
    _x = null;
    _y = null;

    _float = false;

    constructor(...)
    {
        if (vargv.len() == 2)
        {
            _x = (_float) ? vargv[0].tofloat() : _x = round(vargv[0])
            _y = (_float) ? vargv[1].tofloat() : _y = round(vargv[1])
        }
        else if (vargv.len() == 1)
        {
            if (typeof vargv[0] == "scalar2" || typeof vargv[0] == "vec2")
            {
                _x = (_float) ? vargv[0].x.tofloat() : _x = round(vargv[0].x)
                _y = (_float) ? vargv[0].y.tofloat() : _y = round(vargv[0].y)
            }
            else { throw "Unknown object, expecting scalar2 or vec2"; }
        }
        else if (vargv.len() == 0)
        {
            _x = (_float) ? 0.0 : 0;
            _y = (_float) ? 0.0 : 0;
        }
        else { throw "Incorrect number of parameters provided. Please use either () or (x, y)"; }
    }

    function toarray() { return [x, y]; }

    function _typeof() { return "scalar2"; }
    function _tostring() { return format("(%d,%d)", x, y); }
    function _add(o) { return ::vec2(x + o.x, y + o.y); }
    function _sub(o) { return ::vec2(x - o.x, y - o.y); }
    function _mul(o) { return ::vec2(x * o.x, y * o.y); }
    function _div(o) { return ::vec2(x / o.x, y / o.y); }
    function _unm(o) { return ::vec2(-x, -y); }
    function _get(key)
    {
        if (key == "x" || key == "posx" || key == "w" || key == "width")
        {
            return _x;
        }
        else if (key == "y" || key == "posy" || key == "h" || key == "height")
        {
            return _y;
        }
        throw null;
    }
    function _set(key, value)
    {
        if (key == "x" || key == "posx" || key == "w" || key == "width")
        {
            return _x = (_float) ? value.tofloat() : round(value);
        }
        else if (key == "y" || key == "posy" || key == "h" || key == "height")
        {
            return _y = (_float) ? value.tofloat() : round(value);
        }
        throw null;
    }
}

class vec2 extends scalar2
{
    _float = true;

    function _typeof() { return "vec2"; }
    function _tostring() { return format("(%f,%f)", x, y); }
}

class scalar3
{
    _x = null;
    _y = null;
    _z = null;

    _float = false;

    constructor(...)
    {
        if (vargv.len() == 3)
        {
            _x = (_float) ? vargv[0].tofloat() : round(vargv[0]);
            _y = (_float) ? vargv[1].tofloat() : round(vargv[1]);
            _z = (_float) ? vargv[2].tofloat() : round(vargv[2]);
        }
        else if (vargv.len() == 1)
        {
            if (typeof vargv[0] == "scalar3" || typeof vargv[0] == "vec3")
            {
                _x = (_float) ? vargv[0].x.tofloat() : _x = round(vargv[0].x)
                _y = (_float) ? vargv[0].y.tofloat() : _y = round(vargv[0].y)
                _z = (_float) ? vargv[0].z.tofloat() : _y = round(vargv[0].z)
            }
            else { throw "Unknown object, expecting scalar3 or vec3"; }
        }
        else if (vargv.len() == 0)
        {
            _x = (_float) ? 0.0 : 0;
            _y = (_float) ? 0.0 : 0;
            _z = (_float) ? 0.0 : 0;
        }
        else { throw "Incorrect number of parameters provided. Please use either () or (x, y, z)"; }
    }

    function toarray() { return [x, y, z]; }

    function _typeof() { return "scalar3"; }
    function _tostring() { return format("(%d,%d,%d)", x, y, z); }
    function _add(o) { return ::vec2(x + o.x, y + o.y, z + o.z); }
    function _sub(o) { return ::vec2(x - o.x, y - o.y, z - o.z); }
    function _mul(o) { return ::vec2(x * o.x, y * o.y, z * o.z); }
    function _div(o) { return ::vec2(x / o.x, y / o.y, z / o.z); }
    function _unm(o) { return ::vec2(-x, -y, -z); }
    function _get(key)
    {
        if (key == "x" || key == "posx" || key == "r" || key == "red")
        {
            return _x;
        }
        else if (key == "y" || key == "posy" || key == "g" || key == "green")
        {
            return _y;
        }
        else if (key == "z" || key == "posz" || key == "b" || key == "blue")
        {
            return _z;
        }
        throw null;
    }
    function _set(key, value)
    {
        if (key == "x" || key == "r")
        {
            return _x = (_float) ? value.tofloat() : round(value);
        }
        else if (key == "y" || key == "g")
        {
            return _y = (_float) ? value.tofloat() : round(value);
        }
        else if (key == "z" || key == "b")
        {
            return _z = (_float) ? value.tofloat() : round(value);
        }
        throw null;
    }
}

class vec3 extends scalar3
{
    _float = true;

    function _typeof() { return "vec3"; }
    function _tostring() { return format("(%f,%f,%f)", x, y, z); }
}

class scalar4
{
    _x = null;
    _y = null;
    _z = null;
    _w = null;

    _float = false;

    constructor(...)
    {
        if (vargv.len() == 4)
        {
            _x = (_float) ? vargv[0].tofloat() : round(vargv[0]);
            _y = (_float) ? vargv[1].tofloat() : round(vargv[1]);
            _z = (_float) ? vargv[2].tofloat() : round(vargv[2]);
            _w = (_float) ? vargv[3].tofloat() : round(vargv[3]);
        }
        else if (vargv.len() == 1)
        {
            if (typeof vargv[0] == "scalar4" || typeof vargv[0] == "vec4")
            {
                _x = (_float) ? vargv[0].x.tofloat() : _x = round(vargv[0].x)
                _y = (_float) ? vargv[0].y.tofloat() : _y = round(vargv[0].y)
                _z = (_float) ? vargv[0].z.tofloat() : _y = round(vargv[0].z)
                _w = (_float) ? vargv[0].w.tofloat() : _w = round(vargv[0].w)
            }
            else { throw "Unknown object, expecting scalar4 or vec4"; }
        }
        else if (vargv.len() == 0)
        {
            _x = (_float) ? 0.0 : 0;
            _y = (_float) ? 0.0 : 0;
            _z = (_float) ? 0.0 : 0;
            _w = (_float) ? 0.0 : 0;
        }
        else { throw "Incorrect number of parameters provided. Please use either () or (x, y, w, h)"; }
    }

    function toarray() { return [x, y, z, w]; }

    function _typeof() { return "scalar4"; }
    function _tostring() { return format("(%d,%d,%d,%d)", x, y, z, w); }
    function _add(o) { return ::vec2(x + o.x, y + o.y, z + o.z, w + o.w); }
    function _sub(o) { return ::vec2(x - o.x, y - o.y, z - o.z, w - o.w); }
    function _mul(o) { return ::vec2(x * o.x, y * o.y, z * o.z, w * o.w); }
    function _div(o) { return ::vec2(x / o.x, y / o.y, z / o.z, w / o.w); }
    function _unm(o) { return ::vec2(-x, -y, -z, -w); }
    function _get(key)
    {
        if (key == "x" || key == "posx" || key == "r" || key == "red")
        {
            return _x;
        }
        else if (key == "y" || key == "posy" || key == "g" || key == "green")
        {
            return _y;
        }
        else if (key == "z" || key == "posz" || key == "b" || key == "blue" || key == "width")
        {
            return _z;
        }
        else if (key == "w" || key == "scale" || key == "a" || key == "alpha" || key == "height")
        {
            return _w;
        }
        throw null;
    }
    function _set(key, value)
    {
        if (key == "x" || key == "posx" || key == "r" || key == "red")
        {
            return _x = (_float) ? value.tofloat() : round(value);
        }
        else if (key == "y" || key == "posy" || key == "g" || key == "green")
        {
            return _y = (_float) ? value.tofloat() : round(value);
        }
        else if (key == "z" || key == "posz" || key == "b" || key == "blue" || key == "width")
        {
            return _z = (_float) ? value.tofloat() : round(value);
        }
        else if (key == "w" || key == "scale" || key == "a" || key == "alpha" || key == "height")
        {
            return _w = (_float) ? value.tofloat() : round(value);
        }
        throw null;
    }
}

class vec4 extends scalar4
{
    _float = true;

    function _typeof() { return "vec4"; }
    function _tostring() { return format("(%f,%f,%f,%f)", x, y, z, w); }
}
