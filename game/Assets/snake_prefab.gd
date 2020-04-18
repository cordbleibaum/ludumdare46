extends Spatial

export var distanceTolerance = 0.15
export var interpolationStrength = 2

var spine =  {}
var skeleton

var translationHistory = []
var rotationHistory = []

var lastTranslation
var lastDiff = Vector3(0,0,0)

func _ready():
	set_process(true)
	skeleton = get_node("snakeArmature/Skeleton")
	for i in range(0,14):
		spine[i] = skeleton.find_bone("spine_" + str(i))
	
	lastTranslation = translation


func _process(delta):
	if translation.distance_to(lastTranslation) > distanceTolerance:
		translationHistory.push_back((lastTranslation-translation-lastDiff))
		lastDiff = lastTranslation-translation
		lastTranslation = translation
		
		if translationHistory.size() > spine.size():
			translationHistory.pop_front()
			rotationHistory.pop_front()
			
	translate(Vector3(sin(OS.get_ticks_msec()*0.005)*delta*0.5, 0, 0.5*delta))
	
	for i in range (0, translationHistory.size()):
		var currentPose = skeleton.get_bone_custom_pose(spine[translationHistory.size()-i-1])
		var newPose = Transform.translated(translationHistory[i])
		
		var interpolatedPose = currentPose.interpolate_with(newPose, interpolationStrength*delta)
		
		skeleton.set_bone_custom_pose(spine[translationHistory.size()-i-1], interpolatedPose)
		
