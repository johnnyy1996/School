package net.thefourthwall.www;
import static java.lang.Math.sqrt;
import static java.lang.Math.pow;

/**
 * Created by Jonathan on 10/05/17
 */

public class Cone{

    /**
     * This is the cone constructor.
     *
     * @param h - the value of the
     * height of the cone.
     *
     * @param r - the value of the
     * radius of the cone.
     */

    Cone (double h, double r){
		setHeight(h);
		setRadius(r);
	}

    /**
     * Creates a constant value named
     * OUR_PI_CONSTANT and assigns it the value 3.1416
     */
    
	public static final double OUR_PI_CONSTANT = 3.1416;

    /**
     * setHeight sets the height of the
     * cone equal to the value passed
     * in the parameter.
     *
     * @param h - the value to set the
     * height of the cone equal to.
     */
    
	public void setHeight(double h){
		this.height = h;
	}

    /**
     * getHeight returns the height of
     * the cone.
     *
     * @return returns the height of the cone.
     */
    
	public double getHeight(){
		return height;
	}

    /**
     * setRadius sets the radius of the
     * cone equal to the value passed
     * in the parameter.
     *
     * @param r - the value to set the
     * radius of the cone equal to.
     */
    
	public void setRadius(double r){
		this.radius = r;
	}

    /**
     * getRadius returns the radius of
     * the cone.
     *
     * @return returns the radius of the cone.
     */
    
	public double getRadius(){
		return radius;
	}

    /**
     * getArea returns the area of the cone.
     *
     * @return multiplies OUR_PI_CONSTANT times
     * radius times (radius plus the square root
     * of the sum of height squared and radius squared)
     * in order to get the area of the cone.
     */
    
	public double getArea(){
		return OUR_PI_CONSTANT*radius*(radius+sqrt(pow(height,2) + pow(radius,2)));
	}

    /**
     * getVolume returns the voume of the cone.
     *
     * @return multiplies OUR_PI_CONSTANT times
     * radius squared times (height over 3)
     */
    
	public double getVolume(){
		return OUR_PI_CONSTANT*(pow(radius,2)*(height/3));
	}

    /**
     * Creates two protected variables
     * height and radius for the cone.
     */
    
	protected Double height, radius;
}
