using UnityEngine;
using UnityEngine.AI;
using HelpURL = BehaviorDesigner.Runtime.Tasks.HelpURLAttribute;


namespace BehaviorDesigner.Runtime.Tasks.Movement {
    [TaskDescription("Seek the target specified using the Unity NavMesh.")]
    [TaskCategory("Movement")]
    [TaskIcon("Assets/Behavior Designer Movement/Editor/Icons/{SkinColor}SeekIcon.png")]
    
    public class Seek: NavMeshMovement {
        [Tooltip("The GameObject that the agent is seeking")]
        public GameObject itself;
        public SharedString targetTag;
        public SharedGameObject target;
        public SharedVector3 targetPosition;
        //public SharedString targetTag;
        [Tooltip("If target is null then use the target position")] 

        NavMeshAgent agent;
        Animator animator;


        public override void OnStart() {
            base.OnStart();
            agent = GetComponent<NavMeshAgent>();
            animator = GetComponent<Animator>();

            SetDestination(Target());
        }

        // Seek the destination. Return success once the agent has reached the destination.
        // Return running if the agent hasn't reached the destination yet
        public override TaskStatus OnUpdate() {
            //animator.SetBool("Shooting", false);
            animator.SetFloat("Speed", agent.velocity.magnitude);
            animator.SetBool("Shooting", false);

            if (HasArrived()) {
                return TaskStatus.Success;
            }
            
            itself.GetComponent<WeaponIk>().enabled = true;
            
            SetDestination(Target());
            
            //itself.GetComponent<WeaponIk>().target = objectFound;
            return TaskStatus.Running;
        }

        // Return targetPosition if target is null
        private Vector3 Target()
        {
            if (targetTag.Value != null)
            {
                target = itself.GetComponent<WeaponIk>().target;
                return target.Value.transform.position;
            }
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
