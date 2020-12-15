import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { GraphicalComparisonComponent } from './graphicalcomparison.component';

describe('TrendComponent', () => {
  let component: GraphicalComparisonComponent;
  let fixture: ComponentFixture<GraphicalComparisonComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ GraphicalComparisonComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(GraphicalComparisonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
