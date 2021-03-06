extends Node

#database for all possible actions

#scale in runtime if component value is SCALE_X, fixed value otherwise
const SCALE_ATK = -999
const SCALE_SHIELD = -998
const SCALE_HP = -997
const SCALE_DICE = -996

enum Targets {
	ENEMY,
	ONE_PLAYER,
	MULTI_PLAYER,
	MYSELF,
	ALL
}

enum Types {
	DEAL_DAMAGE,
	BUFF_ATTACK,
	HEAL_HP,
	GAIN_SHIELD,
	APPLY_POISON
}

#match enum to skills array
enum Skill_codes {
	NORMAL_ATTACK,
	BLOCK,
	FIREBALL,
	RAGE,
	MINOR_HEALING,
	SHIELD_BASH,
	POISON_FLASK
}

var skills = {
	Skill_codes.NORMAL_ATTACK : {"name": "Normal Attack", "components" : [{"type" : Types.DEAL_DAMAGE, "target" : Targets.ENEMY, "value" : SCALE_ATK}]}, 
	Skill_codes.FIREBALL : {"name": "Fireball", "components" : [{"type" : Types.DEAL_DAMAGE, "target" : Targets.ENEMY, "value" : 10}]},
	Skill_codes.BLOCK : {"name": "Block", "components" : [{"type" : Types.GAIN_SHIELD, "target" : Targets.MYSELF, "value" : 10}]},
	Skill_codes.MINOR_HEALING : {"name": "Minor Healing", "components" : [{"type" : Types.HEAL_HP, "target" : Targets.MYSELF, "value" : 10}]},
	Skill_codes.RAGE : {"name": "Rage", "components" : [{"type" : Types.BUFF_ATTACK, "target" : Targets.MYSELF, "value" : 3}]},
	Skill_codes.SHIELD_BASH : {"name": "Shield Bash", "components" : [{"type" : Types.DEAL_DAMAGE, "target" : Targets.ENEMY, "value" : SCALE_SHIELD}]},
	Skill_codes.POISON_FLASK : {"name": "Poison Flask", "components" : [{"type" : Types.APPLY_POISON, "target" : Targets.ENEMY, "value" : 5}]},
	}

func get_skill_details(code : int):
	return skills[code].name
