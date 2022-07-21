using UnityEngine;
using UnityEngine.AI;

namespace BehaviorDesigner.Runtime.Tasks.Movement {
    [TaskDescription("Seek the target specified using the Unity NavMesh.")]
    [TaskCategory("Movement")][HelpURL("https://www.opsive.com/support/documentation/behavior-designer-movement-pack/")]
    [TaskIcon("Assets/Behavior Designer Movement/Editor/Icons/{SkinColor}SeekIcon.png")]
    public class Seek: NavMeshMovement {
        [Tooltip("The GameObject that the agent is seeking")]
        public GameObject itself;
        public GameObject objectFound;
        public SharedVector3 targetPosition;
        //public SharedString targetTag;
        [Tooltip("If target is null then use the target position")] 

        NavMeshAgent agent;
        Animator animator;

        //////SEE object///////

        public bool usePhysics2D;
        [Tooltip("The object that we are searching for")]
        public SharedGameObject targetObject;
        [Tooltip("The tag of the object that we are searching for")]
        public SharedString targetTag;
        [Tooltip("The LayerMask of the objects that we are searching for")]
        public LayerMask objectLayerMask;
        [Tooltip("If using the object layer mask, specifies the maximum number of colliders that the physics cast can collide with")]
        public int maxCollisionCount = 200;
        [Tooltip("The LayerMask of the objects to ignore when performing the line of sight check")]
        public LayerMask ignoreLayerMask;
        [Tooltip("The field of view angle of the agent (in degrees)")]
        public SharedFloat fieldOfViewAngle = 90;
        [Tooltip("The distance that the agent can see")]
        public SharedFloat viewDistance = 1000;
        [Tooltip("The raycast offset relative to the pivot position")]
        public SharedVector3 offset;
        [Tooltip("The target raycast offset relative to the pivot position")]
        public SharedVector3 targetOffset;
        [Tooltip("The offset to apply to 2D angles")]
        public SharedFloat angleOffset2D;
        [Tooltip("Should the target bone be used?")]
        public SharedBool useTargetBone;
        [Tooltip("The target's bone if the target is a humanoid")]
        public HumanBodyBones targetBone;
        [Tooltip("Should a debug look ray be drawn to the scene view?")]
        public SharedBool drawDebugRay;
        [Tooltip("Should the agent's layer be disabled before the Can See Object check is executed?")]
        public SharedBool disableAgentColliderLayer;
        [Tooltip("The object that is within sight")]
        public SharedGameObject returnedObject;
        /////////

        public override void OnStart() {
            base.OnStart();
            agent = GetComponent<NavMeshAgent>();
            animator = GetComponent<Animator>();

            SetDestination(Target());
        }

        // Seek the destination. Return success once the agent has reached the destination.
        // Return running if the agent hasn't reached the destination yet
        public override TaskStatus OnUpdate() {
            animator.SetFloat("Speed", agent.velocity.magnitude);

            if (HasArrived()) {
                itself.GetComponent<WeaponIk>().enabled = false;
                return TaskStatus.Success;
            }
            
            itself.GetComponent<WeaponIk>().enabled = true;
            SetDestination(Target());
            
            itself.GetComponent<WeaponIk>().target = objectFound;
            return TaskStatus.Running;
        }

        // Return targetPosition if target is null
        private Vector3 Target() {
            if (targetTag.Value != null) {
                if (!string.IsNullOrEmpty(targetTag.Value)) {
                // If the target tag is not null then determine if there are any objects within sight based on the tag
                returnedObject.Value = null;
                objectFound = null;
                float minAngle = Mathf.Infinity;
                var targets = GameObject.FindGameObjectsWithTag(targetTag.Value);

                for (int i = 0; i < targets.Length; ++i) {
                    float angle;
                    GameObject obj;

                    if ((obj = MovementUtility.WithinSight(transform, offset.Value, fieldOfViewAngle.Value, viewDistance.Value, targets[i], targetOffset.Value, false, angleOffset2D.Value, out angle, ignoreLayerMask, useTargetBone.Value, targetBone, drawDebugRay.Value)) != null) {

                        // This object is within sight. Set it to the objectFound GameObject if the angle is less than any of the other objects
                        if (angle < minAngle) {
                            minAngle = angle;
                            objectFound = obj;
                        }
                    }
                }
                returnedObject.Value = objectFound;    
            }
            returnedObject.Value = objectFound;
            return returnedObject.Value.transform.position;
            }
            Debug.Log("nope");
            return targetPosition.Value; 
        }

        //public override void OnReset()
        //{
        //    base.OnReset();
        //    target = null;
        //    targetPosition = Vector3.zero;
        //}
    }
}
