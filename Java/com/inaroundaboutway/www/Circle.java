package com.inaroundaboutway.www;

/**
 * @author Jonathan Garcia
 */

public interface Circle {
	
    /**
     * Creates a constant value named
     * OUR_PI_CONSTANT and assigns it the value 3.14.
     */
    
	public static final double OUR_PI_CONSTANT = 3.14;
	
    /**
     * setRadius sets the radius of the
     * circle equal to the value passed
     * in the parameter.
     *
     * @param r - the value to set the
     * radius of the circle equal to.
     */
    
    void setRadius(double r);
    
    /**
     * getRadius returns the radius of
     * the circle.
     */
  
    double getRadius();
    
    /**
     * getArea is the default method for
     * calculating the area of a circle.
     *
     * @return multiplies the constant variable
     * representing pi by the radius squared.
     */
    
	default double getArea(){
        return OUR_PI_CONSTANT*getRadius()*getRadius();
	}
		
    /**
     * getPerimeter is the default method for
     * calculating the perimeter of a circle.
     *
     * @returns multiplies 2 times the constant
     * variable for pi times the radius.
     */
    
	default double getPerimeter(){
		return 2*OUR_PI_CONSTANT*getRadius();
	}
}
