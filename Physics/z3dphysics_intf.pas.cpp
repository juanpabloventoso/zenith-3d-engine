



 


   typedef interface Iz3DPhysicsEngine['/*AE915254-3A45-4D61-AF82-F4704BC706F2*/ ']
      
Boolean GetEnabled ();
 ;
       
SetEnabled (const Boolean Value 
);
 ;

     
SyncronizeScenarioPhysics ();
 ;
       
PerformWorldsPhysics (const Iz3DScenarioDynamicObject AObject 
);
 ;
        
Boolean PerformCollisionPhysics (const Iz3DScenarioDynamicObject AObject 
);
 ;
       
ApplyPhysics (const Iz3DScenarioDynamicObject AObject 
);
 ;

                
Boolean CheckCollision (const Iz3DScenarioDynamicObject AObjectA ,
const Iz3DScenarioObject AObjectB 
);
 ;
                
Boolean BoundIntersectionTest (const Iz3DScenarioDynamicObject AObjectA ,
const Iz3DScenarioObject AObjectB 
);
 ;

                
Boolean BSvsBSCollisionTest (const Iz3DScenarioDynamicObject AObjectA ,
const Iz3DScenarioObject AObjectB 
);
 ;
                
Boolean AABBvsAABBCollisionTest (const Iz3DScenarioDynamicObject AObjectA ,
const Iz3DScenarioObject AObjectB 
);
 ;

                
Boolean TriangleCollisionTest (const Iz3DScenarioDynamicObject AObjectA ,
const Iz3DScenarioObject AObjectB 
);
 ;

                
Boolean BSvsBSCollisionResponse (const Iz3DScenarioDynamicObject AObjectA ,
const Iz3DScenarioObject AObjectB 
);
 ;

         /** \sa GetEnabled For reading   \sa SetEnabled For writing */
Boolean Enabled; 

 };




// finished

