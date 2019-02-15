package net.thefourthwall.www;
/**
* Created by Jonathan on 10/05/17
*/

public class ConeUser {
	public static void main(String[] args){

		Cone tp1 = new Cone(4,5);
		System.out.println("Cone height is "+tp1.height);
        System.out.println();
        System.out.println();
        System.out.println("Cone radius is "+tp1.radius);
        System.out.println();
        System.out.println();
        System.out.println("Cone surface area is "+tp1.getArea());
        System.out.println();
        System.out.println();
        System.out.println("Cone volume is "+tp1.getVolume());
        System.out.println();
        System.out.println();
	}
}
