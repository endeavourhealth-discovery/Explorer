import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ValueSetEditorComponent } from './valueseteditor.component';

describe('ValueSetEditorComponent', () => {
  let component: ValueSetEditorComponent;
  let fixture: ComponentFixture<ValueSetEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ValueSetEditorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ValueSetEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
