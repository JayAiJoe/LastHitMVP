extends Node

#database for all possible actions

#scale in runtime if component value is SCALE_X, fixed value otherwise
const SCALE_ATK = -999
const SCALE_SHIELD = -998
const SCALE_HP = -997
const SCALE_DICE = -996

enum TriggerType {
	ON_USE,
	ON_PERFORM_ACTION,
	ON_ENCOUNTER_START,
	ON_ENCOUNTER_END,
	ON_ENEMY_HIT,
	ON_DAMAGE_RECEIVE,
	ON_HEAL_RECEIVE
}

enum TargetType {
	SELF,
	NOT_SELF,
	ALLY,
	PLAYER,
	ENEMY,
	EVERYONE,
	CREATURE_SELF,
	CREATURE_OTHER
}

enum TargetNum {
	ALL,
	NONE,
	NUM
}

enum ActionType {
	DAMAGE,
	HEAL,
	SHIELD,
	GIVE_STATUS
}

enum Status {
	STRENGTH,
	DURABLE,
	BARRIER,
	WEAK,
	VULNERABLE,
	POISON
}

enum Attribute {
	ATTACK,
	SHIELD,
	HP,
	DICE
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
	Skill_codes.NORMAL_ATTACK : {"name": "Normal Attack", "components" : [{"trigger" : TriggerType.ON_USE,
																			"target" : TargetType.ENEMY,
																			"target_num" : TargetNum.NUM,
																			"num_targets" : 1,
																			"action" : ActionType.DAMAGE,
																			"scaling" : true,
																			"scale_m" : 1,
																			"scale_b" : 0,
																			"value" : Attribute.ATTACK,
																			"instances" : 1}]}, 
	
	Skill_codes.BLOCK : {"name": "Block", "components" : [{"trigger" : TriggerType.ON_USE,
																			"target" : TargetType.SELF,
																			"action" : ActionType.SHIELD,
																			"scaling" : false,
																			"value" : 10,
																			"instances" : 1}]},
	
	Skill_codes.FIREBALL : {"name": "Fireball", "components" : [{"trigger" : TriggerType.ON_USE,
																			"target" : TargetType.ENEMY,
																			"target_num" : TargetNum.NUM,
																			"num_targets" : 1,
																			"action" : ActionType.DAMAGE,
																			"scaling" : false,
																			"value" : 10,
																			"instances" : 1}]},
	
	Skill_codes.RAGE : {"name": "Rage", "components" : [{"trigger" : TriggerType.ON_USE,
																			"target" : TargetType.SELF,
																			"action" : ActionType.GIVE_STATUS,
																			"status_id" : Status.STRENGTH,
																			"scaling" : false,
																			"value" : 3,
																			"instances" : 1}]},
	
	Skill_codes.MINOR_HEALING : {"name": "Minor Healing", "components" : [{"trigger" : TriggerType.ON_USE,
																			"target" : TargetType.SELF,
																			"action" : ActionType.HEAL,
																			"scaling" : false,
																			"value" : 10,
																			"instances" : 1}]},
	
	Skill_codes.SHIELD_BASH : {"name": "Shield Bash", "components" : [{"trigger" : TriggerType.ON_USE,
																			"target" : TargetType.ENEMY,
																			"target_num" : TargetNum.NUM,
																			"num_targets" : 1,
																			"action" : ActionType.DAMAGE,
																			"scaling" : true,
																			"scale_m" : 1,
																			"scale_b" : 0,
																			"value" : Attribute.SHIELD,
																			"instances" : 1}]}, 
	
	Skill_codes.POISON_FLASK : {"name": "Poison Flask", "components" : [{"trigger" : TriggerType.ON_USE,
																			"target" : TargetType.ENEMY,
																			"target_num" : TargetNum.NUM,
																			"num_targets" : 1,
																			"action" : ActionType.GIVE_STATUS,
																			"status_id" : Status.POISON,
																			"scaling" : false,
																			"value" : 5,
																			"instances" : 1}]}, 
	}

func get_skill_details(code : int):
	return skills[code].name
