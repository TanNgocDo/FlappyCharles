//
//  GameScene.swift
//  FlappyCharles
//
//  Created by Do Ngoc Tan on 10/5/15.
//  Copyright (c) 2015 tando. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    let birdGroup:UInt32 = 1
    let objGroup:UInt32 = 2
    
    var movingObjs = SKNode()
    var isGameOver:Bool = false
    var score = 0
    var scoreLabel = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -5)
        self.addChild(movingObjs)
        var timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "createPipes", userInfo: nil, repeats: true)
        
        self.initBackGround()
        self.initBird()
        self.initGround()
        
        
        
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        bird.physicsBody?.velocity = CGVectorMake(0, 0)
        bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        self.movingObjs.speed = 0
        self.isGameOver = true
    }
    
    func createPipes()  {
        
        if( self.isGameOver == false ) {
            let gapHeight = bird.size.height*4
            var movingDistance = arc4random() % UInt32(self.frame.size.height/2)
            var pipeOffset = CGFloat(movingDistance) - self.frame.size.height/4
            
            
            var movePiles = SKAction.moveByX(-self.frame.size.width*2, y: 0, duration: NSTimeInterval(self.frame.size.width/100))
            var removePipes = SKAction.removeFromParent()
            var moveAndRemovePipes = SKAction.sequence([movePiles,removePipes])
            
            
            
            var pipeTopTexture = SKTexture(imageNamed: "pipeTop")
            var pipeTop = SKSpriteNode(texture: pipeTopTexture)
            pipeTop.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeTop.size.height + pipeOffset )
            
            pipeTop.runAction(moveAndRemovePipes)
            pipeTop.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTop.size)
            pipeTop.physicsBody?.dynamic = false
            pipeTop.physicsBody?.categoryBitMask = self.objGroup
            movingObjs.addChild(pipeTop)
            
            var pipeBottomTexture = SKTexture(imageNamed: "pipeBottom")
            var pipeBottom = SKSpriteNode(texture: pipeBottomTexture)
            pipeBottom.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipeBottom.size.height + pipeOffset )
           
            pipeBottom.runAction(moveAndRemovePipes)
            pipeBottom.physicsBody = SKPhysicsBody(rectangleOfSize: pipeBottom.size)
            pipeBottom.physicsBody?.dynamic = false
            pipeBottom.physicsBody?.categoryBitMask = self.objGroup
            movingObjs.addChild(pipeBottom)
            
            
            
        }
        
        
    }
    
   private func  createSpriteNode(imgName: String, position: CGPoint) ->SKSpriteNode{
        var spriteTexture = SKTexture(imageNamed: imgName )
        var spriteNode = SKSpriteNode(texture: spriteTexture)
        spriteNode.position = position
    
        return spriteNode
    }
    
    private  func initBackGround() {
        var bgTexture = SKTexture(imageNamed: "bg")
        var moveBg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 2.8)
        var replaceBg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        var moveBgForever = SKAction.repeatActionForever(SKAction.sequence([moveBg,replaceBg]))
        
        //create many background to fill the high resolution green
        for var i:CGFloat = 0; i < 4; ++i {
            bg = SKSpriteNode(texture: bgTexture)
            //  bg.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            bg.size.width = self.frame.width
            
            bg.runAction(moveBgForever)
            movingObjs.addChild(bg)
            
        }

    }
    
    private func initBird()  {
        // var birdTextture = SKTexture( imageNamed: "charles" )
        // var birdTextture2 = SKTexture( imageNamed: "flappy2" )
        //var animation = SKAction.animateWithTextures([birdTextture,birdTextture2], timePerFrame: 0.1)
        //var birdFlap = SKAction.repeatActionForever(animation)
        
        //  bird = SKSpriteNode( texture: birdTextture )
        //  bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        // bird.runAction(birdFlap)
        bird  = self.createSpriteNode("charles", position: CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)))
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = true
        bird.zPosition = 20
        bird.physicsBody?.categoryBitMask = self.birdGroup
        //bird.physicsBody?.collisionBitMask = self.objGroup
        bird.physicsBody?.contactTestBitMask = self.objGroup
        
        
        self.addChild(bird)

    }
    
    private func initGround() {
        var ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width,1))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = self.objGroup
        
        
        self.addChild(ground)

    }
}
