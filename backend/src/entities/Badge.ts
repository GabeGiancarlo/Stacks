import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  OneToMany,
} from 'typeorm';
import { UserBadge } from './UserBadge';

export enum BadgeTier {
  BRONZE = 'bronze',
  SILVER = 'silver',
  GOLD = 'gold',
  PLATINUM = 'platinum',
}

@Entity('badges')
export class Badge {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column()
  name!: string;

  @Column({
    type: 'enum',
    enum: BadgeTier,
  })
  tier!: BadgeTier;

  @Column({ name: 'icon_url', nullable: true })
  iconUrl?: string;

  @Column({ type: 'text', nullable: true })
  criteria?: string;

  @OneToMany(() => UserBadge, (userBadge) => userBadge.badge)
  userBadges!: UserBadge[];
}

