import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ValueSetComponent } from './valueset.component';

describe('ValueSetComponent', () => {
  let component: ValueSetComponent;
  let fixture: ComponentFixture<ValueSetComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ValueSetComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ValueSetComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
