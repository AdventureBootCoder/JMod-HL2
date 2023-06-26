

function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	local Pos = self.Position
	
	local emitter = ParticleEmitter( Pos )
	
		for i=1, 5 do
		
			local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos)
				particle:SetVelocity( Vector(math.random(-12,12),math.random(-12,12),math.random(-12,12)) )
				particle:SetDieTime( math.Rand( 3, 5 ) )
				particle:SetStartAlpha( math.Rand( 120, 150 ) )
				particle:SetStartSize( math.Rand(10,20) )
				particle:SetEndSize( math.Rand( 10, 20 ) )
				particle:SetRoll( math.Rand( 360,480 ) )
				particle:SetRollDelta( math.Rand( -10, 10 ) )
				particle:SetColor( math.Rand( 10, 100 ), math.Rand( 10, 150 ), math.Rand( 220, 255 ) )
				--particle:VelocityDecay( true )	
				
			end

				
	local emitter2 = ParticleEmitter( Pos )
		for i=1,10 do
				local particle2 = emitter2:Add( "particles/flamelet"..math.random( 1, 5 ), Pos)
				particle2:SetVelocity( Vector(math.random(-60,60),math.random(-60,60),math.random(-60,60)) )
				particle2:SetDieTime( math.Rand( 1, 2 ) )
				particle2:SetStartAlpha( math.Rand( 50, 10 ) )
				particle2:SetStartSize( math.Rand(10,20) )
				particle2:SetEndSize( math.Rand( 10, 20 ) )
				particle2:SetRoll( math.Rand( 360,480 ) )
				particle2:SetRollDelta( math.Rand( -10, 10 ) )
				particle2:SetColor( math.Rand( 150, 255 ), math.Rand( 10, 150 ), math.Rand( 10, 100 ) )
				--particle2:VelocityDecay( true )
			end
		

	emitter:Finish()
	
end


function EFFECT:Think( )

return false
		
end


function EFFECT:Render()
	-- Do nothing - this effect is only used to spawn the particles in Init
end



