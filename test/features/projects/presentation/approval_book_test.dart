import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/features/projects/presentation/approval_book.dart';

void main() {
  test('records a decision only on the latest version', () {
    final book = ApprovalBook(now: () => DateTime.utc(2026, 10, 29));

    final outdated = book.decide(
      projectId: ApprovalBook.villaId,
      kind: 'quotation',
      version: 3,
      approved: true,
    );
    expect(outdated, contains('outdated'));
    expect(
      book.current(ApprovalBook.villaId, 'quotation')?.status,
      ApprovalStatus.pending,
    );

    final recorded = book.decide(
      projectId: ApprovalBook.villaId,
      kind: 'quotation',
      version: 4,
      approved: true,
      comment: 'Proceed',
    );
    expect(recorded, isNull);
    final current = book.current(ApprovalBook.villaId, 'quotation');
    expect(current?.status, ApprovalStatus.approved);
    expect(current?.comment, 'Proceed');

    final again = book.decide(
      projectId: ApprovalBook.villaId,
      kind: 'quotation',
      version: 4,
      approved: false,
      comment: 'Too late',
    );
    expect(again, contains('already'));
  });

  test('does not expose villa approvals on another project', () {
    final book = ApprovalBook();
    expect(book.current('prj_difc', 'quotation'), isNull);
    expect(book.pendingCount('prj_difc'), 0);
  });
}
