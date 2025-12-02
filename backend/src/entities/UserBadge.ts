import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
  CreateDateColumn,
} from 'typeorm';
import { User } from './User';
import { Badge } from './Badge';

@Entity('user_badges')
export class UserBadge {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ name: 'user_id' })
  userId!: number;

  @Column({ name: 'badge_id' })
  badgeId!: number;

  @CreateDateColumn({ name: 'earned_at' })
  earnedAt!: Date;

  @ManyToOne(() => User, (user) => user.userBadges)
  @JoinColumn({ name: 'user_id' })
  user!: User;

  @ManyToOne(() => Badge, (badge) => badge.userBadges)
  @JoinColumn({ name: 'badge_id' })
  badge!: Badge;
}

