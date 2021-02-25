import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { QueryQueueComponent } from './queryqueue.component';

describe('QueryQueueComponent', () => {
  let component: QueryQueueComponent;
  let fixture: ComponentFixture<QueryQueueComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ QueryQueueComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(QueryQueueComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
