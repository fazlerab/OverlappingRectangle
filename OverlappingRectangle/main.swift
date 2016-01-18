//
//  main.swift
//  OverlappingRectangle
//
//  Created by Imran on 1/16/16.
//  Copyright © 2016 Fazle Rab. All rights reserved.
//


/*
 *  Given the coordinates of two rectangle, this program finds out 
 *  if the two rectanges overlaps or not
 */

import Foundation

struct Point {
    var x:Float
    var y:Float
    
    init(_ xVal:Float, _ yVal:Float) {
        x = xVal
        y = yVal
    }
}

// Return intersection point of two lines or nil for parallel lines
func intersectPointOfLine(line1:[Point], andLine line2:[Point]) -> Point? {
    var intersectionX:Float?
    var intersectionY:Float?
    
    var m1:Float?, b1:Float?
    var m2:Float?, b2:Float?
    
    if line1[0].x == line1[1].x { //check line1 parallel to y-axis: x = a
        intersectionX = line1[0].x
    }
    else if line1[0].y == line1[1].y { //check line1 parallel to x-axis: y = b
        intersectionY = line1[0].y
        m1 = 0
        b1 = line1[0].y
    }
    else {
        // line1 'm' and 'b' of equation y = mx + b
        m1 = (line1[1].y - line1[0].y) / (line1[1].x - line1[0].x)
        b1 = line1[0].y - m1! * line1[0].x
    }
    
    if line2[0].x == line2[1].x { //check line2 parallel to y-axis
        intersectionX = line2[0].x
    }
    else if line2[0].y == line2[1].y { //check line2 parallel to x-axis
        intersectionY = line2[0].y
        m2 = 0
        b2 = line2[0].y
    }
    else {
        // line2 'm' and 'b' of equation y = mx + b
        m2 = (line2[1].y - line2[0].y) / (line2[1].x - line2[0].x)
        b2 = line2[0].y - (m2! * line2[0].x)
    }
    
    // Lines are parallel
    if m1 == m2 {
        print("Parallel lines")
        return nil
    }
    
    // Points where the two lines intersect
    if (intersectionX == nil) {
        intersectionX = (b2! - b1!) / (m1! - m2!)
    }
    
    if (intersectionY == nil) {
        if m1 != nil && m2 != nil {
            intersectionY = (m1!*b2! - m2!*b1!) / (m1! - m2!)
        }
        else {
            let m = (m1 != nil) ? m1! : m2!
            let b = (b1 != nil) ? b1! : m2!
            intersectionY = m * intersectionX! + b
        }
    }
    
    print("Intersection Point:(\(intersectionX!), \(intersectionY!))")

    return Point(intersectionX!, intersectionY!)
}

// Checks if a given point is within a given line
func isPoint(pointX:Point, insideOfLine line:[Point]) -> Bool {
    let xMax = max(line[0].x, line[1].x)
    let xMin = min(line[0].x, line[1].x)
    
    let yMax = max(line[0].y, line[1].y)
    let yMin = min(line[0].y, line[1].y)
    
    let inBetweenXs:Bool = pointX.x >= xMin && pointX.x <= xMax
    let inBetweenYs:Bool = pointX.y >= yMin && pointX.y <= yMax
    
    return inBetweenXs && inBetweenYs
}

// Checks if the two given sides intersects each other
func isSide(side1:[Point], intersectSide side2:[Point]) -> Bool {
    let intersectPoint:Point? = intersectPointOfLine(side1, andLine: side2)
    
    let inSide1 = (intersectPoint != nil) ? isPoint(intersectPoint!, insideOfLine:side1) : false
    let inSide2 = (intersectPoint != nil) ? isPoint(intersectPoint!, insideOfLine:side2) : false
    
    return inSide1 && inSide2
}

// Checks if two rectangles overlap each other.
// If any of the side of  first rectangle intersects any of 
// the sides of second rectangle, then the two triangles overlaps
func isRectangle(rectangle1:[Point], overlapRectangle rectangle2:[Point]) -> Bool {
    var overlaps = false
    
    //For each side of first rectangle, check if it crosses any of the side of second rectangle
    for i in 1...4 {
        let sideOfRect1 = [rectangle1[i-1], rectangle1[i % 4]]
        
        for j in 1...4 {
            let sideOfRect2 = [rectangle2[j-1], rectangle2[j % 4]]
            
            overlaps = isSide(sideOfRect1, intersectSide: sideOfRect2)
            if overlaps {
               break; // Break out loop if sides of the two rectangle crisscrosses
            }
        }
        if overlaps {
            break;
        }
    }
    
    return overlaps
}


let rectangleA = [Point(-2,2), Point(2,2), Point(2,-2), Point(-2,-2)]
let rectangleB = [Point(1, -1), Point(10, -1), Point(10, -12), Point(1,-12)];

let overlap = isRectangle(rectangleA, overlapRectangle: rectangleB)
print("Overlap? \(overlap)\n");

let rectangleC = [Point(1,5), Point(5,0), Point(1,-4), Point(-3,0)]
let rectangleD = [Point(1, -1), Point(10, -1), Point(10, -12), Point(1,-12)];

let overlap2 = isRectangle(rectangleC, overlapRectangle: rectangleD)
print("Overlap2? \(overlap2)\n");


let rectangleE = [Point(1,4), Point(5,0), Point(1,-4), Point(-3,0)]
let rectangleF = [Point(2, -4), Point(10, -4), Point(10, -12), Point(2,-12)];

let overlap3 = isRectangle(rectangleE, overlapRectangle: rectangleF)
print("Overlap3? \(overlap3)\n")
