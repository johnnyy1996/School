package com.inaroundaboutway.www;

/**
 *@author Jonathan Garcia
 */

public class Cylinder implements Circle{
   
    /**
     * This is the cylinder constructor.
     *
     * @param r - the value of the
     * radius of the cylinder.
     *
     * @param h - the value of the
     * height of the cylinder.
     *
     * The constructor also calculates the
     * Surface Area and the Volume of the cylinder.
     */
    
	public Cylinder (double r, double h){
		setRadius(r);
		setHeight(h);
        setSurfaceArea();
        setVolume();
	}
    
    /**
     * setRadius sets the radius of the
     * cylinder equal to the value passed
     * in the parameter.
     *
     * @param r - the value to set the
     * radius of the cylinder equal to.
     */
    
	public void setRadius(double r){
		radius = r;
	}

    /**
     * setHeight sets the height of the
     * cylinder equal to the value passed
     * in the parameter.
     *
     * @param h - the value to set the
     * height of the cylinder equal to.
     */
    
	public void setHeight(double h){
		height = h;
	}
    
    /**
     * getRadius returns the radius of
     * the cylinder.
     *
     * @return returns the radius of the cylinder.
     */

	public double getRadius(){
		return radius;
	}
    
    /**
     * getHeight returns the height of
     * the cylinder.
     *
     * @return returns the height of the cylinder.
     */
    
    public double getHeight(){
        return height;
    }

    /**
    * getSurfaceArea returns the
    * Surface Area of the cylinder.
    *
    * @return returns the Surface Area
    * of the cylinder.
    */
    
    public double getSurfaceArea(){
        return surfaceArea;
    }
    
    /**
     * getVolume returns the Volume
     * of the cylinder.
     *
     * @return returns the Volume of
     * the cylinder.
     */
    
    public double getVolume(){
        return volume;
    }
    
    /**
     * setSurfaceArea calculates the Surface
     * Area of the cylinder and assigns it
     * to the data member "surfaceArea".
     */
    
	public void setSurfaceArea(){
		surfaceArea = (getPerimeter()*height)+(2*(getArea()));
	}

    /**
     * setVolume calculates the Volume
     * of the cylinder and assigns it
     * to the data member "volume".
     */
    
	public void setVolume(){
		volume = (getArea())*height;
	}
    
    /**
     * printInfo will print the attributes
     * of a cylinder in the following format:
     *
     * print the cylinder’s height.
     * print the cylinder’s radius.
     * print the underlying circle's area and perimeter given the radius above.
     * print the cylinder’s surface area.
     * print the cylinder’s volume.
     */

	public void printInfo(){
        System.out.println("The cylinder's height is: " + getHeight() +
                           "\n" + "\n" + "The cylinder radius is: " + getRadius() +
                           "\n" + "\n" + "The underlying circle's area is: " + getArea() +
                           "\n" + "\n" + "The underlying circle's perimeter is: " + getPerimeter() +
                           "\n" + "\n" + "The cylinder surface area is: " + getSurfaceArea() +
                           "\n" + "\n" +"The cylinder volume is: " + getVolume() +
                           "\n" + "\n");
	}
 
    /**
     * Creates two protected variables
     * height and radius and two private
     * variables surfaceArea and volume
     * for the cylinder.
     */
    
    
    private double surfaceArea, volume;
	protected double radius, height;
}
