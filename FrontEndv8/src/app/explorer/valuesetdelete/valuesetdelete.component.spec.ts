import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ValueSetDeleteComponent } from './valuesetdelete.component';

describe('PatientComponent', () => {
  let component: ValueSetDeleteComponent;
  let fixture: ComponentFixture<ValueSetDeleteComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ValueSetDeleteComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ValueSetDeleteComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
