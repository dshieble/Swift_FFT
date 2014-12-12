//My Implementation of the FFT in Swift
//Its a not so fast recursive implementation

import UIKit
import Foundation


//Computes FFT of input Vector
func fft(inout A:[Complex],w:Complex){
    var L = A.count
    if L==1 {
        return
    }
    //Make odd and even arrays
    var indices = 1...L/2
    var Ae = indices.map({A[$0*2-2].copy()})
    var Ao = indices.map({A[$0*2-1].copy()})
    fft(&Ao,w.power(2)) //odds
    fft(&Ae,w.power(2)) //evens
    //Add Polynomials
    for i in 0..<L/2{
        A[i].mimic(Ae[i].plus( w.power(i).times(Ao[i])))
        A[i+L/2].mimic(Ae[i].minus(w.power(i).times(Ao[i])))
    }
}


//"Keeps it real" and returns the magnitude vector of the fft of the input vector
func real_fft(Vector:[Double])->[Double]{
    //Make a complex vector
    var A = Vector.map({Complex(r:$0,i:0)})//Convert to Complex Numbers
    //Zero Pad A
    var C = Int(pow(2.0,ceil(log2(Float(A.count)))))-A.count
    A += [Complex](count:C,repeatedValue:Complex(r:0,i:0))
    //Compute FFT
    fft(&A,nth_root(A.count))
    //Return magnitude vector
    return A.map({$0.magnitude()})
}


//Returns the nth root of unity
func nth_root(n:Int)->Complex{
    if n<=1{
        return Complex(r:1.0,i:0.0)
    }
    let n = Double(n) //for computation purposes
    return Complex(r:cos(2*M_PI/n),i:sin(2*M_PI/n))
}


class Complex {
    var real:Double;
    var imag:Double;
    init(r: Double,i:Double){
        real = r
        imag = i
    }
    //Sum of Complex Numbers
    func plus(c:Complex)->Complex{
        return Complex(r: self.real+c.real,i:self.imag+c.imag)
    }
    //Difference of Complex Numbers
    func minus(c:Complex)->Complex{
        return Complex(r: self.real-c.real,i:self.imag-c.imag)
    }
    //Product of Complex Numbers
    func times(c:Complex)->Complex{
        return Complex(r: (self.real*c.real)-(self.imag*c.imag),i:(self.real*c.imag)+(self.imag*c.real))
    }
    //Exponentiation of Complex Number
    func power(n:Int)->Complex{
        if n == 0{
            return Complex(r:1.0,i:0.0)
        } else {
            return self.times(power(n-1))
        }
    }
    //Absolute Value of Complex Number
    func magnitude()->Double{
        return sqrt(pow(real,2) + pow(imag,2))
    }
    //mimic the parameters of another complex number
    func mimic(c:Complex){
        self.real = c.real
        self.imag = c.imag
    }
    //Create a copy of this complex number
    func copy()->Complex{
        return Complex(r:self.real,i:self.imag)
    }
}


//Try it out here!

//Basic Variables
var len = 31
var f0 = 10.0

//Populate first array
var nums = [Double](count: len,repeatedValue: 0.0)
for i in 0..<len{
    nums[i] = Double(cos(2.0*M_PI*Double(i)*Double(f0)/Double(len)))
}
var out = real_fft(nums)

for i in 0..<len{
    out[i] //Click here to see the graph of the fft magnitude vector!
}

