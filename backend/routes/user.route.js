const express = require('express')
const User = require('../models/user.model')
const router = express.Router()


router.post('/login',(req,res)=>{
    User.findOne({nickname:req.body.nickname},(err,user)=>{
        if(err){
            console.log(err)
            res.json(err)
        }else{
            if(user==null){
                const user = User({
                    nickname:req.body.nickname,
                    password:req.body.password
                })
                user.save()
                .then((err)=>{
                    if(err){
                        console.log(err)
                        res.json(err)
                    }else{
                        console.log(user)
                        res.json(user)
                    }
                    
                })
            }else{

            res.json({
                message:'nickname is not available'
            })   
            }
        }
    })
    
})

router.post('/login',(req,res)=>{
    User.findOne({nickname:req.body.nickname,password:req.body.password},(err,user)=>{
        if(err){
            console.log(err)
            res.json(err)
        }else{
            res.json(user)   
        }
    })
})
module.exports = router