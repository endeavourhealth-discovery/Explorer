import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RegistryDashboardComponent } from './registrydashboard.component';

describe('RegistryIndicatorsComponent', () => {
  let component: RegistryDashboardComponent;
  let fixture: ComponentFixture<RegistryDashboardComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RegistryDashboardComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RegistryDashboardComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
