import { Entity } from '../../../../core/domain/entity';

export type Course = {
  id: string;
  profession: string;
  salaryText: string;
  salaryValue: number;
  startDate: Date;
  discount: number;
  source: 'SkillFactory';
  url: string;
  imageUrl: string;
  landingHash: string;
};

export const validateCourse = (course: any) => {
  const entity = Entity.createEntityValidator<Course>(course, 'Course');

  entity.hasStringValue('id');
  entity.hasStringValue('profession');
  entity.hasStringValue('salaryText');
  entity.hasNumberValue('salaryValue');
  entity.hasValue('startDate');
  entity.hasNumberValue('discount');
  entity.hasStringValue('source');
  entity.hasStringValue('url');
  entity.hasStringValue('imageUrl');
  entity.hasStringValue('landingHash');

  entity.checkWithRules([
    [(c) => !(c.startDate instanceof Date), 'Start date should type of Date'],
    [(c) => c.salaryValue <= 0, 'Incorrect salary value'],
    [(c) => c.discount < 0 || c.discount >= 100, 'Incorrect discount value'],
  ]);
};
