/*

FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End

graphic design by: www.ClanLogoDesign.com
layout scripting by: Chris Van Graas
shader code by: Timothy Lottes, LUKE NUKEM, krischan, Chris Van Graas

Public Functions:
    round(float)
        Round a float value UP to nearest int (Negative numbers get rounded UP as well)
        returns int

    log(obj)
        Output a string message to the console if DEBUG constant is enabled.

    randomize(int)
        Generate a random number, int param sets ceiling.
        returns int

    percent_to_pixel(float, int)
        Convert a percentage value (as a float) to an integer.
        (Used for resolution independant layout positioning)
        returns int

    get_gcd(scalar2)
        Get the greatest common divisor (gcd) of a pair of integers.
        returns int

    get_aspect_ratio_float(scalar2)
        Get the aspect ratio of a pair of integers as a float.
        returns float

    get_aspect_ratio_width(scalar2)
        Get the aspect ratio width of a pair of integers.
        returns int

    get_aspect_ratio_height(scalar2)
        Get the aspect ratio height of a pair of integers.
        returns int

    get_aspect_ratio_dimensions(scalar2)
        Get the aspect ratio width and height of a pair of integers.
        returns scalar()

    set_surface_size_by_image_aspect_ratio_width(fe.surface, fe.image, int)
        Set the dimensions of a surface based on the aspect ratio width of an image.

    set_surface_size_by_image_aspect_ratio_height(fe.surface, fe.image, int)
        Set the dimensions of a surface based on the aspect ratio height of an image.

    set_surface_image_fill(fe.surface, fe.image, scalar2)
        Set an image inside a surface to fill the available space while maintaining the correct aspect ratio.

    set_surface_image_fit(fe.surface, fe.image, scalar2)
        Set an image inside a surface to fit the available space while maintaining the correct aspect ratio.

    truncate_message(fe.text, int)

    get_strength(string)
        Converts a set of 5 strings (strongest, strong, medium, weak, weakest) to a percentage of 255 on a linear scale.
        (Useful for UserConfig settings like "Scanline Strength")
        returns int

*/

const READ_BLOCK_SIZE = 80960;
const PHI = 1.618033988749;
local next_ln_overflow=""; // used by the get_next_ln() function

function generate_indexes(config)
{
    local return_history = "";
    local return_mameinfo = "";
    if (config["options_history"] == "Enabled") return_history = generate_index("History", config["historydat_path"], config["index_clones"]);
    if (config["options_mameinfo"] == "Enabled") return_mameinfo = generate_index("MAMEInfo", config["mameinfodat_path"], config["index_clones"]);

    if (return_history != "" && return_mameinfo != "")
    {
        return return_history + "\n" + return_mameinfo;
    }
    else if (return_history == "") return return_mameinfo;
    else return return_history;
}

function generate_index(dat_type, datfile_name, index_clones)
{
    local history_idx_path = FeConfigDirectory + "history.idx/";
    local mameinfo_idx_path = FeConfigDirectory + "mameinfo.idx/";
    local datfile = null;

    try
    {
        datfile = file(datfile_name, "rb");
    }
    catch ( e )
    {
        return "Error opening file: " + datfile_name;
    }

    local indices = {};

    local last_per=0;

    //
    // Get an index for all the entries in history.dat
    //
    while ( !datfile.eos() )
    {
        local base_pos = datfile.tell();
        local blb = datfile.readblob( READ_BLOCK_SIZE );

        // Update the user with the percentage complete
        local percent = 100.0 * ( datfile.tell().tofloat() / datfile.len().tofloat() );
        if ( percent.tointeger() > last_per )
        {
            last_per = percent.tointeger();
            if ( fe.overlay.splash_message(
                    "Generating " + dat_type + " index ("
                    + last_per + "%)" ) )
                break; // break loop if user cancels
        }
        
        while ( !blb.eos() )
        {
            local line = scan_for_ctrl_ln( blb );

            if ( line.len() < 5 ) // skips $bio, $end
                continue;

            local eq = line.find( "=", 1 );
            if ( eq != null )
            {
                local systems = split( line.slice(1,eq), "," );
                local roms = split( line.slice(eq+1), "," );

                foreach ( s in systems )
                {
                    if ( !indices.rawin( s ) )
                        indices[ s ] <- {};

                    if (index_clones == "Yes")
                    {
                        foreach ( r in roms )
                            (indices[ s ])[ r ]
                                <- ( base_pos + blb.tell() );
                    }
                    else if ( roms.len() > 0 )
                    {
                        (indices[ s ])[ roms[0] ]
                            <- ( base_pos + blb.tell() );
                    }
                }
            }
        }
    }

    //
    // Make sure the directory we are writing to exists...
    //
    local idx_path = "";
    if (dat_type == "History") idx_path = history_idx_path;
    else if (dat_type == "MAMEInfo") idx_path = mameinfo_idx_path;

    system( "mkdir \"" + idx_path + "\"" );
    fe.overlay.splash_message( "Writing index file." );

    //
    // Now write an index file for each system encountered
    //
    foreach ( n,l in indices )
    {
        local idx = file( idx_path + n + ".idx", "w" );
        foreach ( rn,ri in l )
            write_ln( idx, rn + ";" + ri + "\n" );

        idx.close();
    }

    datfile.close();

    return "Created index for " + indices.len()
        + " systems in " + idx_path;
}

//
// Get a single line of input from f
//
function get_next_ln( f )
{
    local ln = next_ln_overflow;
    next_ln_overflow="";
    while ( !f.eos() )
    {
        local char = f.readn( 'b' );
        if ( char == '\n' )
            return strip( ln );

        ln += char.tochar();
    }

    next_ln_overflow=ln;
    return "";
}

//
// Write a single line of output to f
//
function write_ln( f, line )
{
    local b = blob( line.len() );

    for (local i=0; i<line.len(); i++)
        b.writen( line[i], 'b' );

    f.writeblob( b );
}

//
// Scan through f and return the next line starting with a "$"
//
function scan_for_ctrl_ln( f )
{
    local char;
    while ( !f.eos() )
    {
        char = f.readn( 'b' );
        if (( char == '\n' ) && ( !f.eos() ))
        {
            char = f.readn( 'b' );
            if ( char == '$' )
            {
                next_ln_overflow="$";
                return get_next_ln( f );
            }
        }
    }
    return "";
}



function round(value)
{
    return floor(value + 0.5);
}

function log(msg)
{
    if (msg == null) msg = "null";
    msg = format("[%s v%s]: %s\n", LAYOUT_NAME, VERSION.tostring(), msg.tostring());
    if (DEBUG) print(msg);
}

function randomize(max_value)
{
    return rand() * max_value / RAND_MAX;
}

function percent_to_pixel(percent, context)
{
    return round(percent * context);
}

function get_gcd(dimensions) { return (dimensions.height == 0) ? dimensions.width : get_gcd(scalar2(dimensions.height, dimensions.width % dimensions.height)); }

function get_aspect_ratio_float(dimensions) { return dimensions.width / dimensions.height.tofloat(); }

function get_aspect_ratio_width(dimensions)
{
    local gcd = get_gcd(dimensions);
    if (gcd != 0) return dimensions.width / gcd;
    return 0;
}

function get_aspect_ratio_height(dimensions)
{
    local gcd = get_gcd(dimensions);
    if (gcd != 0) return dimensions.height / gcd;
    return 0;
}

function get_aspect_ratio_dimensions(dimensions)
{
    return scalar2(get_aspect_ratio_width(dimensions), get_aspect_ratio_height(dimensions));
}

function set_surface_size_by_image_aspect_ratio_width(surface, image, max_width)
{
    local image_aspect_ratio = scalar2();
    local texture_size = scalar2(image.texture_width, image.texture_height);
    image_aspect_ratio.w = get_aspect_ratio_width(texture_size);
    image_aspect_ratio.h = get_aspect_ratio_height(texture_size);

    // dodgey hack for scraped images with bad aspect ratio
    if (image_aspect_ratio.w == 222 && image_aspect_ratio.h == 167)
    {
        image_aspect_ratio.w = 4;
        image_aspect_ratio.h = 3;
    }

    local unit = (image_aspect_ratio.w == 0) ? 0 : max_width / image_aspect_ratio.w;

    surface.width = max_width;
    surface.height = unit * image_aspect_ratio.h;
}

function set_surface_size_by_image_aspect_ratio_height(surface, image, max_height)
{
    local image_aspect_ratio = scalar2();
    local texture_size = scalar2(image.texture_width, image.texture_height);
    image_aspect_ratio.w = get_aspect_ratio_width(texture_size);
    image_aspect_ratio.h = get_aspect_ratio_height(texture_size);

    // dodgey hack for scraped images with bad aspect ratio
    if (image_aspect_ratio.w == 167 && image_aspect_ratio.h == 222)
    {
        image_aspect_ratio.w = 3;
        image_aspect_ratio.h = 4;
    }

    local unit = (image_aspect_ratio.h == 0) ? 0 : max_height / image_aspect_ratio.h;

    surface.width = unit * image_aspect_ratio.w;
    surface.height = max_height;
}

function set_surface_image_fill(surface, image, max_dimensions)
{
    local texture_size = scalar2(image.texture_width, image.texture_height);
    local ar_f = vec2(get_aspect_ratio_float(texture_size), get_aspect_ratio_float(max_dimensions));

    if (ar_f.x >= ar_f.y) { set_surface_size_by_image_aspect_ratio_height(surface, image, max_dimensions.height); }
    else { set_surface_size_by_image_aspect_ratio_width(surface, image, max_dimensions.width); }
}

function set_surface_image_fit(surface, image, max_dimensions)
{
    local texture_size = scalar2(image.texture_width, image.texture_height);
    local ar_f = vec2(get_aspect_ratio_float(texture_size), get_aspect_ratio_float(max_dimensions));

    if (ar_f.x >= ar_f.y) { set_surface_size_by_image_aspect_ratio_width(surface, image, max_dimensions.width); }
    else { set_surface_size_by_image_aspect_ratio_height(surface, image, max_dimensions.height); }
}

function truncate_message(text_obj, max_length)
{
    if (text_obj.msg_width > max_length)
    {
        while (text_obj.msg_width > max_length)
        {
            text_obj.msg = text_obj.msg.slice(0, text_obj.msg.len() - 1);
            text_obj.msg = strip(text_obj.msg);
        }

        text_obj.msg = text_obj.msg.slice(0, text_obj.msg.len() - 1);
        text_obj.msg = strip(text_obj.msg);
        text_obj.msg += "...";
    }
}

function get_strength(strength)
{
    local unit;
    switch (strength)
    {
        case "Strongest":
            unit = 100;
            break;
        case "Strong":
            unit = 80;
            break;
        case "Medium":
            unit = 60;
            break;
        case "Weak":
            unit = 40;
            break;
        case "Weakest":
            unit = 20;
            break;
        case "Disabled":
            unit = 0;
            break;
    }
    return 255 * (unit / 100.0);
}
