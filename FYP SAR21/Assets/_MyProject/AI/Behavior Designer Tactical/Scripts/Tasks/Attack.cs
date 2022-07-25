using UnityEngine;
using BehaviorDesigner.Runtime.Tasks;
using Tooltip = BehaviorDesigner.Runtime.Tasks.TooltipAttribute;
using HelpURL = BehaviorDesigner.Runtime.Tasks.HelpURLAttribute;
using UnityEngine.AI;

namespace BehaviorDesigner.Runtime.Tactical.Tasks
{
    [TaskCategory("Tactical")]
    [TaskDescription("Moves to the closest target and starts attacking as soon as the agent is within distance")]
    [HelpURL("https://www.opsive.com/support/documentation/behavior-designer-tactical-pack/")]
    [TaskIcon("Assets/Behavior Designer Tactical/Editor/Icons/{SkinColor}AttackIcon.png")]
    public class Attack : NavMeshTacticalGroup
    {
        public GameObject itself;
        NavMeshAgent agent;
        Animator animator;
        public override TaskStatus OnUpdate()
        {
            var baseStatus = base.OnUpdate();
            agent = GetComponent<NavMeshAgent>();
            animator = GetComponent<Animator>();
            itself.GetComponent<WeaponIk>().enabled = true;
            
            animator.SetFloat("Speed", agent.velocity.magnitude);
            
            
            if (baseStatus != TaskStatus.Running || !started) {
                //animator.SetBool("Shooting", false);
                return baseStatus;
            }

            if (MoveToAttackPosition()) { 
                //agent.velocity.magnitude = 0;
                itself.GetComponent<WeaponIk>().enabled = true;
                tacticalAgent.TryAttack();
            }
            return TaskStatus.Running;
        }
    }
}