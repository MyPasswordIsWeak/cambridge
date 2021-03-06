local Piece = require 'tetris.components.piece'
local Ruleset = require 'tetris.rulesets.ruleset'

local ARS = Ruleset:extend()

ARS.name = "ACE-ARS"
ARS.hash = "ArikaACE"

ARS.colourscheme = {
    I = "C",
    L = "O",
    J = "B",
    S = "G",
    Z = "R",
    O = "Y",
    T = "M",
}

ARS.softdrop_lock = false
ARS.harddrop_lock = true

ARS.spawn_positions = {
	I = { x=5, y=2 },
	J = { x=4, y=3 },
	L = { x=4, y=3 },
	O = { x=5, y=3 },
	S = { x=4, y=3 },
	T = { x=4, y=3 },
	Z = { x=4, y=3 },
}

ARS.big_spawn_positions = {
	I = { x=3, y=0 },
	J = { x=2, y=1 },
	L = { x=2, y=1 },
	O = { x=3, y=1 },
	S = { x=2, y=1 },
	T = { x=2, y=1 },
	Z = { x=2, y=1 },
}

ARS.block_offsets = {
	I={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=0, y=2} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=0, y=2} },
	},
	J={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=-1, y=-1} },
		{ {x=0, y=-1}, {x=1, y=-2}, {x=0, y=-2}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0}, {x=-1, y=0} },
	},
	L={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=1, y=-1} },
		{ {x=0, y=-2}, {x=0, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=-1, y=0} },
		{ {x=0, y=-1}, {x=-1, y=-2}, {x=0, y=-2}, {x=0, y=0} },
	},
	O={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
	},
	S={
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=-1, y=-2}, {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0} },
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=-1, y=-2}, {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0} },
	},
	T={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=0, y=-1} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-1}, {x=0, y=-2} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=-1, y=-1}, {x=0, y=-2} },
	},
	Z={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-2}, {x=1, y=-1} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-2}, {x=1, y=-1} },
	}
}


-- Component functions.

function ARS:attemptWallkicks(piece, new_piece, rot_dir, grid)

	-- O doesn't kick
	if (piece.shape == "O") then return end

	-- center column rule
	if (
		piece.shape == "J" or piece.shape == "T" or piece.shape == "L"
	) and (
		piece.rotation == 0 or piece.rotation == 2
	) then
        local offsets = new_piece:getBlockOffsets()
        table.sort(offsets, function(A, B) return A.y < B.y or A.y == B.y and A.x < B.y end)
        for index, offset in pairs(offsets) do
            if grid:isOccupied(piece.position.x + offset.x, piece.position.y + offset.y) then
                if offset.x == 0 then
                    return 
                else
                    break
                end
            end
        end
    end

	if piece.shape == "I" then
		-- special kick rules for I
		if new_piece.rotation == 0 or new_piece.rotation == 2 then
			-- kick right, right2, left
			if grid:canPlacePiece(new_piece:withOffset({x=1, y=0})) then
				piece:setRelativeRotation(rot_dir):setOffset({x=1, y=0})
				self:onPieceRotate(piece, grid)
			elseif grid:canPlacePiece(new_piece:withOffset({x=2, y=0})) then
				piece:setRelativeRotation(rot_dir):setOffset({x=2, y=0})
				self:onPieceRotate(piece, grid)
			elseif grid:canPlacePiece(new_piece:withOffset({x=-1, y=0})) then
				piece:setRelativeRotation(rot_dir):setOffset({x=-1, y=0})
				self:onPieceRotate(piece, grid)
			end
		elseif piece:isDropBlocked(grid) and (new_piece.rotation == 1 or new_piece.rotation == 3) and piece.floorkick == 0 then
			-- kick up, up2
			if grid:canPlacePiece(new_piece:withOffset({x=0, y=-1})) then
				piece:setRelativeRotation(rot_dir):setOffset({x=0, y=-1})
				self:onPieceRotate(piece, grid)
				piece.floorkick = 1
			elseif grid:canPlacePiece(new_piece:withOffset({x=0, y=-2})) then
				piece:setRelativeRotation(rot_dir):setOffset({x=0, y=-2})
				self:onPieceRotate(piece, grid)
				piece.floorkick = 1
			end
		end
	else
        -- kick right, kick left
        if grid:canPlacePiece(new_piece:withOffset({x=1, y=0})) then
            piece:setRelativeRotation(rot_dir):setOffset({x=1, y=0})
        elseif grid:canPlacePiece(new_piece:withOffset({x=-1, y=0})) then
            piece:setRelativeRotation(rot_dir):setOffset({x=-1, y=0})
        elseif piece.shape == "T"
           and new_piece.rotation == 1
           and piece.floorkick == 0
           and grid:canPlacePiece(new_piece:withOffset({x=0, y=-1}))
        then
            -- T floorkick
            piece.floorkick = piece.floorkick + 1
            piece:setRelativeRotation(rot_dir):setOffset({x=0, y=-1})
        end
	end

end

function ARS:onPieceCreate(piece, grid)
	piece.floorkick = 0
	piece.manipulations = 0
end

function ARS:onPieceDrop(piece, grid)
	piece.lock_delay = 0 -- step reset
end

function ARS:onPieceMove(piece, grid)
	piece.lock_delay = 0 -- move reset
	if piece:isDropBlocked(grid) then
		piece.manipulations = piece.manipulations + 1
		if piece.manipulations >= 127 then
			piece.locked = true
		end
	end
end

function ARS:onPieceRotate(piece, grid)
	piece.lock_delay = 0 -- rotate reset
	if piece:isDropBlocked(grid) then
		piece.manipulations = piece.manipulations + 1
		if piece.manipulations >= 127 then
			piece.locked = true
		end
	end
end

function ARS:get180RotationValue() return 3 end
function ARS:getDefaultOrientation() return 3 end  -- downward facing pieces by default

return ARS
