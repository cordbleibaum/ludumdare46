extends Spatial

#export var distanceTolerance = 0.15
#export var interpolationStrength = 2

#var spine =  {}
onready var skeleton = $snakeArmature/Skeleton

#onready var ikHandles = [$snakeArmature/Skeleton/ikHandle5, $snakeArmature/Skeleton/ikHandle4, $snakeArmature/Skeleton/ikHandle3, $snakeArmature/Skeleton/ikHandle2, $snakeArmature/Skeleton/ikHandle1]
#onready var ikNodes =  [$snakeArmaature/Skeleton/ikHandle5, $snakeArmature/Skeleton/ikHandle4, $snakeArmature/Skeleton/ikHandle3, $snakeArmature/Skeleton/ikHandle2, $snakeArmature/Skeleton/ikHandle1]
onready var ikHandles = []
onready var ikNodes =  []

var bonelengths = []

var interpolationTimes = []
onready var mesh = preload("res://testBalls.tscn")
onready var goal = preload("res://goalBalls.tscn")


var translationHistory = []
var historyIndices = []
var currentBonesPositions = []
var ikViz = []
#var rotationHistory = []

#var lastTranslation
#var lastDiff = Vector3(0,0,0)
var timer = 0

var currentTime : float = 0

func _quadratic_bezier(p0: Vector3, p1: Vector3, p2: Vector3, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	var r = q0.linear_interpolate(q1, t)
	return r

func _ready():
	var boneName : String = "spine_"
	var counter : int = 0
	var boneID : int = skeleton.find_bone(boneName + String(counter))
	var offset = 2
	counter += offset
	currentBonesPositions.push_back(global_transform.origin)
	while boneID != -1:
		boneID = skeleton.find_bone(boneName + String(counter))
		if boneID != -1:
			var ik = SkeletonIK.new()
			skeleton.add_child(ik)
			ikNodes.push_back(ik)
			ik.root_bone = boneName + String(counter-offset)
			ik.tip_bone = boneName + String(counter)
			var bonePosition : Vector3 = skeleton.get_bone_global_pose(boneID).origin
			var bonePosition1 : Vector3 = skeleton.get_bone_global_pose(boneID-offset).origin
			bonelengths.push_back((bonePosition - bonePosition1).length())
			currentBonesPositions.push_back(bonePosition)
#			print(bonePosition)
#			var ikHandle = Spatial.new()
#			ikHandle.name = "ikHandle" + String(boneID-1)
#			add_child(ikHandle)
#			ikHandle.global_transform.origin = bonePosition
#
#			ikHandles.push_back(ikHandle)
#			var path : NodePath = ik.get_path_to(ikHandle)
#			ik.set_target_node(path)
			ik.start()
		counter += 1
	
	translationHistory.push_back(global_transform.origin)
	for i in range(len(ikNodes)):
		interpolationTimes.push_back(0.0)
		translationHistory.push_back(currentBonesPositions[i+1])
		var g = goal.instance()
		add_child(g)
		g.global_transform.origin = currentBonesPositions[i+1]
		ikViz.push_back(g)

	historyIndices = range(len(ikNodes))


func _process(delta):
#	if translation.distance_to(lastTranslation) > distanceTolerance:
#		translationHistory.push_back((lastTranslation-translation-lastDiff))
#		lastDiff = lastTranslation-translation
#		lastTranslation = translation
#
#		if translationHistory.size() > spine.size():
#			translationHistory.pop_front()
#			rotationHistory.pop_front()
	
	timer += delta
	if timer < 0.1:
		return
	timer = 0.0
	
	currentTime += delta

	var v : Vector3 = Vector3(sin(currentTime * PI * 5) * 0.025, 0, 0.5*delta)
	translate(v)

#	if (translationHistory[-1] - global_transform.origin).length() > 0.05:
	translationHistory.push_back(global_transform.origin)
	currentBonesPositions[0] = global_transform.origin

	for i in range(len(ikNodes)):
		var index : int = historyIndices[i]
#		while index < (len(translationHistory) - 2):
#			if (translationHistory[index] - currentBonesPositions[i]).length() < bonelengths[i]:
#				index = index-1
#				break
#			index += 1
#
#		var oldPos : Vector3 = translationHistory[index]
#		var futurePos0 : Vector3 = translationHistory[index+1]
#
#		var close0 = (oldPos - currentBonesPositions[i]).length() - bonelengths[i]
#		var close1 = (futurePos0 - currentBonesPositions[i]).length() - bonelengths[i]
#		if close0 < close1:
#			interpolationTimes[i] = close0/(close0+close1)
#		else:
#			interpolationTimes[i] = 1 - (close0/(close0+close1))
#
##		var dist : float = (futurePos0-oldPos).length()
##		if dist != 0:
##			interpolationTimes[i] += v.length()/dist
#
#		currentBonesPositions[i+1] = oldPos.linear_interpolate(futurePos0, interpolationTimes[i])
##		ikHandles[i].global_transform.origin = newPos
#		ikNodes[i].set_target_transform(Transform(Basis(), currentBonesPositions[i+1]))
#		if interpolationTimes[i] >= 1.0:
#			interpolationTimes[i] = 0.0
#			historyIndices[i] += 1
#		ikViz[i].translation = currentBonesPositions[i+1]

