import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { PracticelistsizesComponent } from './practicelistsizes.component';

describe('PracticelistsizesComponent', () => {
  let component: PracticelistsizesComponent;
  let fixture: ComponentFixture<PracticelistsizesComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ PracticelistsizesComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(PracticelistsizesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
