import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DashboardEditorComponent } from './dashboardeditor.component';

describe('PatientComponent', () => {
  let component: DashboardEditorComponent;
  let fixture: ComponentFixture<DashboardEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DashboardEditorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DashboardEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
