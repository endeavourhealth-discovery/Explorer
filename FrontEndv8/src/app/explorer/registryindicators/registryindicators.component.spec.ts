import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RegistryindicatorsComponent } from './registryindicators.component';

describe('RegistryIndicatorsComponent', () => {
  let component: RegistryindicatorsComponent;
  let fixture: ComponentFixture<RegistryindicatorsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RegistryindicatorsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RegistryindicatorsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
