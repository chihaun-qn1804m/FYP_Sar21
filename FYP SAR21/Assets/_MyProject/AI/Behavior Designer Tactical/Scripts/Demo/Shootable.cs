﻿using UnityEngine;
using UnityEngine.AI;

namespace BehaviorDesigner.Runtime.Tactical
{
    /// <summary>
    /// Example component which will attack by firing a bullet.
    /// </summary>
    public class Shootable : MonoBehaviour, IAttackAgent
    {
        // The bullet prefab to fire
        public GameObject bullet;
        // The furthest distance that the agent is able to attack from
        public float attackDistance;
        // The amount of time it takes for the agent to be able to attack again
        public float repeatAttackDelay;
        // The maximum angle that the agent can attack from
        public float attackAngle;
        public GameObject target;
        Animator animator;
        public Transform aimTransform;

        // The last time the agent attacked
        private float lastAttackTime;

        /// <summary>
        /// Initialize the default values.
        /// </summary>
        private void Awake()
        {
            
            animator = GetComponent<Animator>();
            lastAttackTime = -repeatAttackDelay;
        }

        /// <summary>
        /// Returns the furthest distance that the agent is able to attack from.
        /// </summary>
        /// <returns>The distance that the agent can attack from.</returns>
        public float AttackDistance()
        {
            return attackDistance;
        }

        /// <summary>
        /// Can the agent attack?
        /// </summary>
        /// <returns>Returns true if the agent can attack.</returns>
        public bool CanAttack()
        {
            animator.SetBool("Shooting", true);
            return lastAttackTime + repeatAttackDelay < Time.time;
        }

        /// <summary>
        /// Returns the maximum angle that the agent can attack from.
        /// </summary>
        /// <returns>The maximum angle that the agent can attack from.</returns>
        public float AttackAngle()
        {
            return attackAngle;
        }

        /// <summary>
        /// Does the actual attack. 
        /// </summary>
        /// <param name="targetPosition">The position to attack.</param>
        public void Attack(Vector3 targetPosition)
        {
            
            GameObject.Instantiate(bullet, aimTransform.position, Quaternion.LookRotation(targetPosition - aimTransform.position));
            lastAttackTime = Time.time;
        }
    }
}