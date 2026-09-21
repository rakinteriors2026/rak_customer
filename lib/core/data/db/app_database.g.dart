// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts
    with TableInfo<$AccountsTable, AccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasProjectsMeta = const VerificationMeta(
    'hasProjects',
  );
  @override
  late final GeneratedColumn<bool> hasProjects = GeneratedColumn<bool>(
    'has_projects',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_projects" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    phone,
    displayName,
    hasProjects,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('has_projects')) {
      context.handle(
        _hasProjectsMeta,
        hasProjects.isAcceptableOrUnknown(
          data['has_projects']!,
          _hasProjectsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hasProjectsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      hasProjects: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_projects'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class AccountRow extends DataClass implements Insertable<AccountRow> {
  final String id;
  final String phone;
  final String displayName;
  final bool hasProjects;
  final DateTime createdAt;
  const AccountRow({
    required this.id,
    required this.phone,
    required this.displayName,
    required this.hasProjects,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['phone'] = Variable<String>(phone);
    map['display_name'] = Variable<String>(displayName);
    map['has_projects'] = Variable<bool>(hasProjects);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      phone: Value(phone),
      displayName: Value(displayName),
      hasProjects: Value(hasProjects),
      createdAt: Value(createdAt),
    );
  }

  factory AccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRow(
      id: serializer.fromJson<String>(json['id']),
      phone: serializer.fromJson<String>(json['phone']),
      displayName: serializer.fromJson<String>(json['displayName']),
      hasProjects: serializer.fromJson<bool>(json['hasProjects']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phone': serializer.toJson<String>(phone),
      'displayName': serializer.toJson<String>(displayName),
      'hasProjects': serializer.toJson<bool>(hasProjects),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AccountRow copyWith({
    String? id,
    String? phone,
    String? displayName,
    bool? hasProjects,
    DateTime? createdAt,
  }) => AccountRow(
    id: id ?? this.id,
    phone: phone ?? this.phone,
    displayName: displayName ?? this.displayName,
    hasProjects: hasProjects ?? this.hasProjects,
    createdAt: createdAt ?? this.createdAt,
  );
  AccountRow copyWithCompanion(AccountsCompanion data) {
    return AccountRow(
      id: data.id.present ? data.id.value : this.id,
      phone: data.phone.present ? data.phone.value : this.phone,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      hasProjects: data.hasProjects.present
          ? data.hasProjects.value
          : this.hasProjects,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRow(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('displayName: $displayName, ')
          ..write('hasProjects: $hasProjects, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, phone, displayName, hasProjects, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRow &&
          other.id == this.id &&
          other.phone == this.phone &&
          other.displayName == this.displayName &&
          other.hasProjects == this.hasProjects &&
          other.createdAt == this.createdAt);
}

class AccountsCompanion extends UpdateCompanion<AccountRow> {
  final Value<String> id;
  final Value<String> phone;
  final Value<String> displayName;
  final Value<bool> hasProjects;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.phone = const Value.absent(),
    this.displayName = const Value.absent(),
    this.hasProjects = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String phone,
    required String displayName,
    required bool hasProjects,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       phone = Value(phone),
       displayName = Value(displayName),
       hasProjects = Value(hasProjects),
       createdAt = Value(createdAt);
  static Insertable<AccountRow> custom({
    Expression<String>? id,
    Expression<String>? phone,
    Expression<String>? displayName,
    Expression<bool>? hasProjects,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phone != null) 'phone': phone,
      if (displayName != null) 'display_name': displayName,
      if (hasProjects != null) 'has_projects': hasProjects,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? phone,
    Value<String>? displayName,
    Value<bool>? hasProjects,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      displayName: displayName ?? this.displayName,
      hasProjects: hasProjects ?? this.hasProjects,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (hasProjects.present) {
      map['has_projects'] = Variable<bool>(hasProjects.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('displayName: $displayName, ')
          ..write('hasProjects: $hasProjects, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OtpChallengesTable extends OtpChallenges
    with TableInfo<$OtpChallengesTable, OtpChallengeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OtpChallengesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resendAfterMeta = const VerificationMeta(
    'resendAfter',
  );
  @override
  late final GeneratedColumn<DateTime> resendAfter = GeneratedColumn<DateTime>(
    'resend_after',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _consumedMeta = const VerificationMeta(
    'consumed',
  );
  @override
  late final GeneratedColumn<bool> consumed = GeneratedColumn<bool>(
    'consumed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("consumed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    phone,
    purpose,
    code,
    expiresAt,
    resendAfter,
    consumed,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'otp_challenges';
  @override
  VerificationContext validateIntegrity(
    Insertable<OtpChallengeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
      );
    } else if (isInserting) {
      context.missing(_purposeMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('resend_after')) {
      context.handle(
        _resendAfterMeta,
        resendAfter.isAcceptableOrUnknown(
          data['resend_after']!,
          _resendAfterMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_resendAfterMeta);
    }
    if (data.containsKey('consumed')) {
      context.handle(
        _consumedMeta,
        consumed.isAcceptableOrUnknown(data['consumed']!, _consumedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OtpChallengeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OtpChallengeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      purpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
      resendAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resend_after'],
      )!,
      consumed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}consumed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $OtpChallengesTable createAlias(String alias) {
    return $OtpChallengesTable(attachedDatabase, alias);
  }
}

class OtpChallengeRow extends DataClass implements Insertable<OtpChallengeRow> {
  final String id;
  final String phone;
  final String purpose;
  final String code;
  final DateTime expiresAt;
  final DateTime resendAfter;
  final bool consumed;
  final DateTime createdAt;
  const OtpChallengeRow({
    required this.id,
    required this.phone,
    required this.purpose,
    required this.code,
    required this.expiresAt,
    required this.resendAfter,
    required this.consumed,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['phone'] = Variable<String>(phone);
    map['purpose'] = Variable<String>(purpose);
    map['code'] = Variable<String>(code);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    map['resend_after'] = Variable<DateTime>(resendAfter);
    map['consumed'] = Variable<bool>(consumed);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OtpChallengesCompanion toCompanion(bool nullToAbsent) {
    return OtpChallengesCompanion(
      id: Value(id),
      phone: Value(phone),
      purpose: Value(purpose),
      code: Value(code),
      expiresAt: Value(expiresAt),
      resendAfter: Value(resendAfter),
      consumed: Value(consumed),
      createdAt: Value(createdAt),
    );
  }

  factory OtpChallengeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OtpChallengeRow(
      id: serializer.fromJson<String>(json['id']),
      phone: serializer.fromJson<String>(json['phone']),
      purpose: serializer.fromJson<String>(json['purpose']),
      code: serializer.fromJson<String>(json['code']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
      resendAfter: serializer.fromJson<DateTime>(json['resendAfter']),
      consumed: serializer.fromJson<bool>(json['consumed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phone': serializer.toJson<String>(phone),
      'purpose': serializer.toJson<String>(purpose),
      'code': serializer.toJson<String>(code),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
      'resendAfter': serializer.toJson<DateTime>(resendAfter),
      'consumed': serializer.toJson<bool>(consumed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OtpChallengeRow copyWith({
    String? id,
    String? phone,
    String? purpose,
    String? code,
    DateTime? expiresAt,
    DateTime? resendAfter,
    bool? consumed,
    DateTime? createdAt,
  }) => OtpChallengeRow(
    id: id ?? this.id,
    phone: phone ?? this.phone,
    purpose: purpose ?? this.purpose,
    code: code ?? this.code,
    expiresAt: expiresAt ?? this.expiresAt,
    resendAfter: resendAfter ?? this.resendAfter,
    consumed: consumed ?? this.consumed,
    createdAt: createdAt ?? this.createdAt,
  );
  OtpChallengeRow copyWithCompanion(OtpChallengesCompanion data) {
    return OtpChallengeRow(
      id: data.id.present ? data.id.value : this.id,
      phone: data.phone.present ? data.phone.value : this.phone,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      code: data.code.present ? data.code.value : this.code,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      resendAfter: data.resendAfter.present
          ? data.resendAfter.value
          : this.resendAfter,
      consumed: data.consumed.present ? data.consumed.value : this.consumed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OtpChallengeRow(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('purpose: $purpose, ')
          ..write('code: $code, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('resendAfter: $resendAfter, ')
          ..write('consumed: $consumed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    phone,
    purpose,
    code,
    expiresAt,
    resendAfter,
    consumed,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OtpChallengeRow &&
          other.id == this.id &&
          other.phone == this.phone &&
          other.purpose == this.purpose &&
          other.code == this.code &&
          other.expiresAt == this.expiresAt &&
          other.resendAfter == this.resendAfter &&
          other.consumed == this.consumed &&
          other.createdAt == this.createdAt);
}

class OtpChallengesCompanion extends UpdateCompanion<OtpChallengeRow> {
  final Value<String> id;
  final Value<String> phone;
  final Value<String> purpose;
  final Value<String> code;
  final Value<DateTime> expiresAt;
  final Value<DateTime> resendAfter;
  final Value<bool> consumed;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const OtpChallengesCompanion({
    this.id = const Value.absent(),
    this.phone = const Value.absent(),
    this.purpose = const Value.absent(),
    this.code = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.resendAfter = const Value.absent(),
    this.consumed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OtpChallengesCompanion.insert({
    required String id,
    required String phone,
    required String purpose,
    required String code,
    required DateTime expiresAt,
    required DateTime resendAfter,
    this.consumed = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       phone = Value(phone),
       purpose = Value(purpose),
       code = Value(code),
       expiresAt = Value(expiresAt),
       resendAfter = Value(resendAfter),
       createdAt = Value(createdAt);
  static Insertable<OtpChallengeRow> custom({
    Expression<String>? id,
    Expression<String>? phone,
    Expression<String>? purpose,
    Expression<String>? code,
    Expression<DateTime>? expiresAt,
    Expression<DateTime>? resendAfter,
    Expression<bool>? consumed,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phone != null) 'phone': phone,
      if (purpose != null) 'purpose': purpose,
      if (code != null) 'code': code,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (resendAfter != null) 'resend_after': resendAfter,
      if (consumed != null) 'consumed': consumed,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OtpChallengesCompanion copyWith({
    Value<String>? id,
    Value<String>? phone,
    Value<String>? purpose,
    Value<String>? code,
    Value<DateTime>? expiresAt,
    Value<DateTime>? resendAfter,
    Value<bool>? consumed,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return OtpChallengesCompanion(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      purpose: purpose ?? this.purpose,
      code: code ?? this.code,
      expiresAt: expiresAt ?? this.expiresAt,
      resendAfter: resendAfter ?? this.resendAfter,
      consumed: consumed ?? this.consumed,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (resendAfter.present) {
      map['resend_after'] = Variable<DateTime>(resendAfter.value);
    }
    if (consumed.present) {
      map['consumed'] = Variable<bool>(consumed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OtpChallengesCompanion(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('purpose: $purpose, ')
          ..write('code: $code, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('resendAfter: $resendAfter, ')
          ..write('consumed: $consumed, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuthSessionsTable extends AuthSessions
    with TableInfo<$AuthSessionsTable, AuthSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _accessTokenMeta = const VerificationMeta(
    'accessToken',
  );
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
    'access_token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refreshTokenMeta = const VerificationMeta(
    'refreshToken',
  );
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
    'refresh_token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    accessToken,
    refreshToken,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuthSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('access_token')) {
      context.handle(
        _accessTokenMeta,
        accessToken.isAcceptableOrUnknown(
          data['access_token']!,
          _accessTokenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accessTokenMeta);
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
        _refreshTokenMeta,
        refreshToken.isAcceptableOrUnknown(
          data['refresh_token']!,
          _refreshTokenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_refreshTokenMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuthSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      accessToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_token'],
      )!,
      refreshToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refresh_token'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
    );
  }

  @override
  $AuthSessionsTable createAlias(String alias) {
    return $AuthSessionsTable(attachedDatabase, alias);
  }
}

class AuthSessionRow extends DataClass implements Insertable<AuthSessionRow> {
  final String id;
  final String accountId;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  const AuthSessionRow({
    required this.id,
    required this.accountId,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['access_token'] = Variable<String>(accessToken);
    map['refresh_token'] = Variable<String>(refreshToken);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    return map;
  }

  AuthSessionsCompanion toCompanion(bool nullToAbsent) {
    return AuthSessionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      accessToken: Value(accessToken),
      refreshToken: Value(refreshToken),
      expiresAt: Value(expiresAt),
    );
  }

  factory AuthSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthSessionRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      accessToken: serializer.fromJson<String>(json['accessToken']),
      refreshToken: serializer.fromJson<String>(json['refreshToken']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'accessToken': serializer.toJson<String>(accessToken),
      'refreshToken': serializer.toJson<String>(refreshToken),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
    };
  }

  AuthSessionRow copyWith({
    String? id,
    String? accountId,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) => AuthSessionRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    accessToken: accessToken ?? this.accessToken,
    refreshToken: refreshToken ?? this.refreshToken,
    expiresAt: expiresAt ?? this.expiresAt,
  );
  AuthSessionRow copyWithCompanion(AuthSessionsCompanion data) {
    return AuthSessionRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      accessToken: data.accessToken.present
          ? data.accessToken.value
          : this.accessToken,
      refreshToken: data.refreshToken.present
          ? data.refreshToken.value
          : this.refreshToken,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthSessionRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, accountId, accessToken, refreshToken, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthSessionRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.accessToken == this.accessToken &&
          other.refreshToken == this.refreshToken &&
          other.expiresAt == this.expiresAt);
}

class AuthSessionsCompanion extends UpdateCompanion<AuthSessionRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> accessToken;
  final Value<String> refreshToken;
  final Value<DateTime> expiresAt;
  final Value<int> rowid;
  const AuthSessionsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthSessionsCompanion.insert({
    required String id,
    required String accountId,
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       accessToken = Value(accessToken),
       refreshToken = Value(refreshToken),
       expiresAt = Value(expiresAt);
  static Insertable<AuthSessionRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? accessToken,
    Expression<String>? refreshToken,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (accessToken != null) 'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? accessToken,
    Value<String>? refreshToken,
    Value<DateTime>? expiresAt,
    Value<int>? rowid,
  }) {
    return AuthSessionsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthSessionsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects
    with TableInfo<$ProjectsTable, ProjectRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siteLabelMeta = const VerificationMeta(
    'siteLabel',
  );
  @override
  late final GeneratedColumn<String> siteLabel = GeneratedColumn<String>(
    'site_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phaseCodeMeta = const VerificationMeta(
    'phaseCode',
  );
  @override
  late final GeneratedColumn<String> phaseCode = GeneratedColumn<String>(
    'phase_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phaseLabelMeta = const VerificationMeta(
    'phaseLabel',
  );
  @override
  late final GeneratedColumn<String> phaseLabel = GeneratedColumn<String>(
    'phase_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressPercentMeta = const VerificationMeta(
    'progressPercent',
  );
  @override
  late final GeneratedColumn<int> progressPercent = GeneratedColumn<int>(
    'progress_percent',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetHandoverAtMeta = const VerificationMeta(
    'targetHandoverAt',
  );
  @override
  late final GeneratedColumn<DateTime> targetHandoverAt =
      GeneratedColumn<DateTime>(
        'target_handover_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _forecastHandoverAtMeta =
      const VerificationMeta('forecastHandoverAt');
  @override
  late final GeneratedColumn<DateTime> forecastHandoverAt =
      GeneratedColumn<DateTime>(
        'forecast_handover_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortCursorMeta = const VerificationMeta(
    'sortCursor',
  );
  @override
  late final GeneratedColumn<String> sortCursor = GeneratedColumn<String>(
    'sort_cursor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    name,
    siteLabel,
    phaseCode,
    phaseLabel,
    progressPercent,
    targetHandoverAt,
    forecastHandoverAt,
    updatedAt,
    sortCursor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('site_label')) {
      context.handle(
        _siteLabelMeta,
        siteLabel.isAcceptableOrUnknown(data['site_label']!, _siteLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_siteLabelMeta);
    }
    if (data.containsKey('phase_code')) {
      context.handle(
        _phaseCodeMeta,
        phaseCode.isAcceptableOrUnknown(data['phase_code']!, _phaseCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseCodeMeta);
    }
    if (data.containsKey('phase_label')) {
      context.handle(
        _phaseLabelMeta,
        phaseLabel.isAcceptableOrUnknown(data['phase_label']!, _phaseLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseLabelMeta);
    }
    if (data.containsKey('progress_percent')) {
      context.handle(
        _progressPercentMeta,
        progressPercent.isAcceptableOrUnknown(
          data['progress_percent']!,
          _progressPercentMeta,
        ),
      );
    }
    if (data.containsKey('target_handover_at')) {
      context.handle(
        _targetHandoverAtMeta,
        targetHandoverAt.isAcceptableOrUnknown(
          data['target_handover_at']!,
          _targetHandoverAtMeta,
        ),
      );
    }
    if (data.containsKey('forecast_handover_at')) {
      context.handle(
        _forecastHandoverAtMeta,
        forecastHandoverAt.isAcceptableOrUnknown(
          data['forecast_handover_at']!,
          _forecastHandoverAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sort_cursor')) {
      context.handle(
        _sortCursorMeta,
        sortCursor.isAcceptableOrUnknown(data['sort_cursor']!, _sortCursorMeta),
      );
    } else if (isInserting) {
      context.missing(_sortCursorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      siteLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site_label'],
      )!,
      phaseCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase_code'],
      )!,
      phaseLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase_label'],
      )!,
      progressPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress_percent'],
      ),
      targetHandoverAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_handover_at'],
      ),
      forecastHandoverAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}forecast_handover_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      sortCursor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_cursor'],
      )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class ProjectRow extends DataClass implements Insertable<ProjectRow> {
  final String id;
  final String accountId;
  final String name;
  final String siteLabel;
  final String phaseCode;
  final String phaseLabel;
  final int? progressPercent;
  final DateTime? targetHandoverAt;
  final DateTime? forecastHandoverAt;
  final DateTime updatedAt;
  final String sortCursor;
  const ProjectRow({
    required this.id,
    required this.accountId,
    required this.name,
    required this.siteLabel,
    required this.phaseCode,
    required this.phaseLabel,
    this.progressPercent,
    this.targetHandoverAt,
    this.forecastHandoverAt,
    required this.updatedAt,
    required this.sortCursor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['name'] = Variable<String>(name);
    map['site_label'] = Variable<String>(siteLabel);
    map['phase_code'] = Variable<String>(phaseCode);
    map['phase_label'] = Variable<String>(phaseLabel);
    if (!nullToAbsent || progressPercent != null) {
      map['progress_percent'] = Variable<int>(progressPercent);
    }
    if (!nullToAbsent || targetHandoverAt != null) {
      map['target_handover_at'] = Variable<DateTime>(targetHandoverAt);
    }
    if (!nullToAbsent || forecastHandoverAt != null) {
      map['forecast_handover_at'] = Variable<DateTime>(forecastHandoverAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sort_cursor'] = Variable<String>(sortCursor);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      name: Value(name),
      siteLabel: Value(siteLabel),
      phaseCode: Value(phaseCode),
      phaseLabel: Value(phaseLabel),
      progressPercent: progressPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(progressPercent),
      targetHandoverAt: targetHandoverAt == null && nullToAbsent
          ? const Value.absent()
          : Value(targetHandoverAt),
      forecastHandoverAt: forecastHandoverAt == null && nullToAbsent
          ? const Value.absent()
          : Value(forecastHandoverAt),
      updatedAt: Value(updatedAt),
      sortCursor: Value(sortCursor),
    );
  }

  factory ProjectRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      name: serializer.fromJson<String>(json['name']),
      siteLabel: serializer.fromJson<String>(json['siteLabel']),
      phaseCode: serializer.fromJson<String>(json['phaseCode']),
      phaseLabel: serializer.fromJson<String>(json['phaseLabel']),
      progressPercent: serializer.fromJson<int?>(json['progressPercent']),
      targetHandoverAt: serializer.fromJson<DateTime?>(
        json['targetHandoverAt'],
      ),
      forecastHandoverAt: serializer.fromJson<DateTime?>(
        json['forecastHandoverAt'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sortCursor: serializer.fromJson<String>(json['sortCursor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'name': serializer.toJson<String>(name),
      'siteLabel': serializer.toJson<String>(siteLabel),
      'phaseCode': serializer.toJson<String>(phaseCode),
      'phaseLabel': serializer.toJson<String>(phaseLabel),
      'progressPercent': serializer.toJson<int?>(progressPercent),
      'targetHandoverAt': serializer.toJson<DateTime?>(targetHandoverAt),
      'forecastHandoverAt': serializer.toJson<DateTime?>(forecastHandoverAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'sortCursor': serializer.toJson<String>(sortCursor),
    };
  }

  ProjectRow copyWith({
    String? id,
    String? accountId,
    String? name,
    String? siteLabel,
    String? phaseCode,
    String? phaseLabel,
    Value<int?> progressPercent = const Value.absent(),
    Value<DateTime?> targetHandoverAt = const Value.absent(),
    Value<DateTime?> forecastHandoverAt = const Value.absent(),
    DateTime? updatedAt,
    String? sortCursor,
  }) => ProjectRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    name: name ?? this.name,
    siteLabel: siteLabel ?? this.siteLabel,
    phaseCode: phaseCode ?? this.phaseCode,
    phaseLabel: phaseLabel ?? this.phaseLabel,
    progressPercent: progressPercent.present
        ? progressPercent.value
        : this.progressPercent,
    targetHandoverAt: targetHandoverAt.present
        ? targetHandoverAt.value
        : this.targetHandoverAt,
    forecastHandoverAt: forecastHandoverAt.present
        ? forecastHandoverAt.value
        : this.forecastHandoverAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sortCursor: sortCursor ?? this.sortCursor,
  );
  ProjectRow copyWithCompanion(ProjectsCompanion data) {
    return ProjectRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      name: data.name.present ? data.name.value : this.name,
      siteLabel: data.siteLabel.present ? data.siteLabel.value : this.siteLabel,
      phaseCode: data.phaseCode.present ? data.phaseCode.value : this.phaseCode,
      phaseLabel: data.phaseLabel.present
          ? data.phaseLabel.value
          : this.phaseLabel,
      progressPercent: data.progressPercent.present
          ? data.progressPercent.value
          : this.progressPercent,
      targetHandoverAt: data.targetHandoverAt.present
          ? data.targetHandoverAt.value
          : this.targetHandoverAt,
      forecastHandoverAt: data.forecastHandoverAt.present
          ? data.forecastHandoverAt.value
          : this.forecastHandoverAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sortCursor: data.sortCursor.present
          ? data.sortCursor.value
          : this.sortCursor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('siteLabel: $siteLabel, ')
          ..write('phaseCode: $phaseCode, ')
          ..write('phaseLabel: $phaseLabel, ')
          ..write('progressPercent: $progressPercent, ')
          ..write('targetHandoverAt: $targetHandoverAt, ')
          ..write('forecastHandoverAt: $forecastHandoverAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortCursor: $sortCursor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    name,
    siteLabel,
    phaseCode,
    phaseLabel,
    progressPercent,
    targetHandoverAt,
    forecastHandoverAt,
    updatedAt,
    sortCursor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.name == this.name &&
          other.siteLabel == this.siteLabel &&
          other.phaseCode == this.phaseCode &&
          other.phaseLabel == this.phaseLabel &&
          other.progressPercent == this.progressPercent &&
          other.targetHandoverAt == this.targetHandoverAt &&
          other.forecastHandoverAt == this.forecastHandoverAt &&
          other.updatedAt == this.updatedAt &&
          other.sortCursor == this.sortCursor);
}

class ProjectsCompanion extends UpdateCompanion<ProjectRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> name;
  final Value<String> siteLabel;
  final Value<String> phaseCode;
  final Value<String> phaseLabel;
  final Value<int?> progressPercent;
  final Value<DateTime?> targetHandoverAt;
  final Value<DateTime?> forecastHandoverAt;
  final Value<DateTime> updatedAt;
  final Value<String> sortCursor;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.name = const Value.absent(),
    this.siteLabel = const Value.absent(),
    this.phaseCode = const Value.absent(),
    this.phaseLabel = const Value.absent(),
    this.progressPercent = const Value.absent(),
    this.targetHandoverAt = const Value.absent(),
    this.forecastHandoverAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sortCursor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String accountId,
    required String name,
    required String siteLabel,
    required String phaseCode,
    required String phaseLabel,
    this.progressPercent = const Value.absent(),
    this.targetHandoverAt = const Value.absent(),
    this.forecastHandoverAt = const Value.absent(),
    required DateTime updatedAt,
    required String sortCursor,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       name = Value(name),
       siteLabel = Value(siteLabel),
       phaseCode = Value(phaseCode),
       phaseLabel = Value(phaseLabel),
       updatedAt = Value(updatedAt),
       sortCursor = Value(sortCursor);
  static Insertable<ProjectRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? name,
    Expression<String>? siteLabel,
    Expression<String>? phaseCode,
    Expression<String>? phaseLabel,
    Expression<int>? progressPercent,
    Expression<DateTime>? targetHandoverAt,
    Expression<DateTime>? forecastHandoverAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? sortCursor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (name != null) 'name': name,
      if (siteLabel != null) 'site_label': siteLabel,
      if (phaseCode != null) 'phase_code': phaseCode,
      if (phaseLabel != null) 'phase_label': phaseLabel,
      if (progressPercent != null) 'progress_percent': progressPercent,
      if (targetHandoverAt != null) 'target_handover_at': targetHandoverAt,
      if (forecastHandoverAt != null)
        'forecast_handover_at': forecastHandoverAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sortCursor != null) 'sort_cursor': sortCursor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? name,
    Value<String>? siteLabel,
    Value<String>? phaseCode,
    Value<String>? phaseLabel,
    Value<int?>? progressPercent,
    Value<DateTime?>? targetHandoverAt,
    Value<DateTime?>? forecastHandoverAt,
    Value<DateTime>? updatedAt,
    Value<String>? sortCursor,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      siteLabel: siteLabel ?? this.siteLabel,
      phaseCode: phaseCode ?? this.phaseCode,
      phaseLabel: phaseLabel ?? this.phaseLabel,
      progressPercent: progressPercent ?? this.progressPercent,
      targetHandoverAt: targetHandoverAt ?? this.targetHandoverAt,
      forecastHandoverAt: forecastHandoverAt ?? this.forecastHandoverAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sortCursor: sortCursor ?? this.sortCursor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (siteLabel.present) {
      map['site_label'] = Variable<String>(siteLabel.value);
    }
    if (phaseCode.present) {
      map['phase_code'] = Variable<String>(phaseCode.value);
    }
    if (phaseLabel.present) {
      map['phase_label'] = Variable<String>(phaseLabel.value);
    }
    if (progressPercent.present) {
      map['progress_percent'] = Variable<int>(progressPercent.value);
    }
    if (targetHandoverAt.present) {
      map['target_handover_at'] = Variable<DateTime>(targetHandoverAt.value);
    }
    if (forecastHandoverAt.present) {
      map['forecast_handover_at'] = Variable<DateTime>(
        forecastHandoverAt.value,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (sortCursor.present) {
      map['sort_cursor'] = Variable<String>(sortCursor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('siteLabel: $siteLabel, ')
          ..write('phaseCode: $phaseCode, ')
          ..write('phaseLabel: $phaseLabel, ')
          ..write('progressPercent: $progressPercent, ')
          ..write('targetHandoverAt: $targetHandoverAt, ')
          ..write('forecastHandoverAt: $forecastHandoverAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortCursor: $sortCursor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MilestonesTable extends Milestones
    with TableInfo<$MilestonesTable, MilestoneRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MilestonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortIndexMeta = const VerificationMeta(
    'sortIndex',
  );
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
    'sort_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedAtMeta = const VerificationMeta(
    'plannedAt',
  );
  @override
  late final GeneratedColumn<DateTime> plannedAt = GeneratedColumn<DateTime>(
    'planned_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    title,
    state,
    sortIndex,
    plannedAt,
    completedAt,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'milestones';
  @override
  VerificationContext validateIntegrity(
    Insertable<MilestoneRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('sort_index')) {
      context.handle(
        _sortIndexMeta,
        sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_sortIndexMeta);
    }
    if (data.containsKey('planned_at')) {
      context.handle(
        _plannedAtMeta,
        plannedAt.isAcceptableOrUnknown(data['planned_at']!, _plannedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MilestoneRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MilestoneRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      sortIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_index'],
      )!,
      plannedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}planned_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $MilestonesTable createAlias(String alias) {
    return $MilestonesTable(attachedDatabase, alias);
  }
}

class MilestoneRow extends DataClass implements Insertable<MilestoneRow> {
  final String id;
  final String projectId;
  final String title;
  final String state;
  final int sortIndex;
  final DateTime? plannedAt;
  final DateTime? completedAt;
  final String? note;
  const MilestoneRow({
    required this.id,
    required this.projectId,
    required this.title,
    required this.state,
    required this.sortIndex,
    this.plannedAt,
    this.completedAt,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['title'] = Variable<String>(title);
    map['state'] = Variable<String>(state);
    map['sort_index'] = Variable<int>(sortIndex);
    if (!nullToAbsent || plannedAt != null) {
      map['planned_at'] = Variable<DateTime>(plannedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  MilestonesCompanion toCompanion(bool nullToAbsent) {
    return MilestonesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      title: Value(title),
      state: Value(state),
      sortIndex: Value(sortIndex),
      plannedAt: plannedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory MilestoneRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MilestoneRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      title: serializer.fromJson<String>(json['title']),
      state: serializer.fromJson<String>(json['state']),
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
      plannedAt: serializer.fromJson<DateTime?>(json['plannedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'title': serializer.toJson<String>(title),
      'state': serializer.toJson<String>(state),
      'sortIndex': serializer.toJson<int>(sortIndex),
      'plannedAt': serializer.toJson<DateTime?>(plannedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'note': serializer.toJson<String?>(note),
    };
  }

  MilestoneRow copyWith({
    String? id,
    String? projectId,
    String? title,
    String? state,
    int? sortIndex,
    Value<DateTime?> plannedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => MilestoneRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    title: title ?? this.title,
    state: state ?? this.state,
    sortIndex: sortIndex ?? this.sortIndex,
    plannedAt: plannedAt.present ? plannedAt.value : this.plannedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    note: note.present ? note.value : this.note,
  );
  MilestoneRow copyWithCompanion(MilestonesCompanion data) {
    return MilestoneRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      title: data.title.present ? data.title.value : this.title,
      state: data.state.present ? data.state.value : this.state,
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
      plannedAt: data.plannedAt.present ? data.plannedAt.value : this.plannedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MilestoneRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('state: $state, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('plannedAt: $plannedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    title,
    state,
    sortIndex,
    plannedAt,
    completedAt,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MilestoneRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.title == this.title &&
          other.state == this.state &&
          other.sortIndex == this.sortIndex &&
          other.plannedAt == this.plannedAt &&
          other.completedAt == this.completedAt &&
          other.note == this.note);
}

class MilestonesCompanion extends UpdateCompanion<MilestoneRow> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> title;
  final Value<String> state;
  final Value<int> sortIndex;
  final Value<DateTime?> plannedAt;
  final Value<DateTime?> completedAt;
  final Value<String?> note;
  final Value<int> rowid;
  const MilestonesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.title = const Value.absent(),
    this.state = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.plannedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MilestonesCompanion.insert({
    required String id,
    required String projectId,
    required String title,
    required String state,
    required int sortIndex,
    this.plannedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       title = Value(title),
       state = Value(state),
       sortIndex = Value(sortIndex);
  static Insertable<MilestoneRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? title,
    Expression<String>? state,
    Expression<int>? sortIndex,
    Expression<DateTime>? plannedAt,
    Expression<DateTime>? completedAt,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (title != null) 'title': title,
      if (state != null) 'state': state,
      if (sortIndex != null) 'sort_index': sortIndex,
      if (plannedAt != null) 'planned_at': plannedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MilestonesCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? title,
    Value<String>? state,
    Value<int>? sortIndex,
    Value<DateTime?>? plannedAt,
    Value<DateTime?>? completedAt,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return MilestonesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      state: state ?? this.state,
      sortIndex: sortIndex ?? this.sortIndex,
      plannedAt: plannedAt ?? this.plannedAt,
      completedAt: completedAt ?? this.completedAt,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
    }
    if (plannedAt.present) {
      map['planned_at'] = Variable<DateTime>(plannedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MilestonesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('state: $state, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('plannedAt: $plannedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortIndexMeta = const VerificationMeta(
    'sortIndex',
  );
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
    'sort_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, sortIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_index')) {
      context.handle(
        _sortIndexMeta,
        sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_sortIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_index'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String id;
  final String name;
  final int sortIndex;
  const CategoryRow({
    required this.id,
    required this.name,
    required this.sortIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['sort_index'] = Variable<int>(sortIndex);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      sortIndex: Value(sortIndex),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'sortIndex': serializer.toJson<int>(sortIndex),
    };
  }

  CategoryRow copyWith({String? id, String? name, int? sortIndex}) =>
      CategoryRow(
        id: id ?? this.id,
        name: name ?? this.name,
        sortIndex: sortIndex ?? this.sortIndex,
      );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortIndex: $sortIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortIndex == this.sortIndex);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> sortIndex;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    required int sortIndex,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       sortIndex = Value(sortIndex);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? sortIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortIndex != null) 'sort_index': sortIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? sortIndex,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortIndex: sortIndex ?? this.sortIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products
    with TableInfo<$ProductsTable, ProductRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salesModeMeta = const VerificationMeta(
    'salesMode',
  );
  @override
  late final GeneratedColumn<String> salesMode = GeneratedColumn<String>(
    'sales_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMinorMeta = const VerificationMeta(
    'priceMinor',
  );
  @override
  late final GeneratedColumn<int> priceMinor = GeneratedColumn<int>(
    'price_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _specsMeta = const VerificationMeta('specs');
  @override
  late final GeneratedColumn<String> specs = GeneratedColumn<String>(
    'specs',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageHintMeta = const VerificationMeta(
    'imageHint',
  );
  @override
  late final GeneratedColumn<String> imageHint = GeneratedColumn<String>(
    'image_hint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publishedMeta = const VerificationMeta(
    'published',
  );
  @override
  late final GeneratedColumn<bool> published = GeneratedColumn<bool>(
    'published',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("published" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortCursorMeta = const VerificationMeta(
    'sortCursor',
  );
  @override
  late final GeneratedColumn<String> sortCursor = GeneratedColumn<String>(
    'sort_cursor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    name,
    description,
    salesMode,
    priceMinor,
    currency,
    specs,
    imageHint,
    published,
    sortCursor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('sales_mode')) {
      context.handle(
        _salesModeMeta,
        salesMode.isAcceptableOrUnknown(data['sales_mode']!, _salesModeMeta),
      );
    } else if (isInserting) {
      context.missing(_salesModeMeta);
    }
    if (data.containsKey('price_minor')) {
      context.handle(
        _priceMinorMeta,
        priceMinor.isAcceptableOrUnknown(data['price_minor']!, _priceMinorMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('specs')) {
      context.handle(
        _specsMeta,
        specs.isAcceptableOrUnknown(data['specs']!, _specsMeta),
      );
    } else if (isInserting) {
      context.missing(_specsMeta);
    }
    if (data.containsKey('image_hint')) {
      context.handle(
        _imageHintMeta,
        imageHint.isAcceptableOrUnknown(data['image_hint']!, _imageHintMeta),
      );
    } else if (isInserting) {
      context.missing(_imageHintMeta);
    }
    if (data.containsKey('published')) {
      context.handle(
        _publishedMeta,
        published.isAcceptableOrUnknown(data['published']!, _publishedMeta),
      );
    }
    if (data.containsKey('sort_cursor')) {
      context.handle(
        _sortCursorMeta,
        sortCursor.isAcceptableOrUnknown(data['sort_cursor']!, _sortCursorMeta),
      );
    } else if (isInserting) {
      context.missing(_sortCursorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      salesMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sales_mode'],
      )!,
      priceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_minor'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      specs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specs'],
      )!,
      imageHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_hint'],
      )!,
      published: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}published'],
      )!,
      sortCursor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_cursor'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class ProductRow extends DataClass implements Insertable<ProductRow> {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final String salesMode;
  final int? priceMinor;
  final String currency;
  final String specs;
  final String imageHint;
  final bool published;
  final String sortCursor;
  const ProductRow({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.salesMode,
    this.priceMinor,
    required this.currency,
    required this.specs,
    required this.imageHint,
    required this.published,
    required this.sortCursor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_id'] = Variable<String>(categoryId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['sales_mode'] = Variable<String>(salesMode);
    if (!nullToAbsent || priceMinor != null) {
      map['price_minor'] = Variable<int>(priceMinor);
    }
    map['currency'] = Variable<String>(currency);
    map['specs'] = Variable<String>(specs);
    map['image_hint'] = Variable<String>(imageHint);
    map['published'] = Variable<bool>(published);
    map['sort_cursor'] = Variable<String>(sortCursor);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      name: Value(name),
      description: Value(description),
      salesMode: Value(salesMode),
      priceMinor: priceMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(priceMinor),
      currency: Value(currency),
      specs: Value(specs),
      imageHint: Value(imageHint),
      published: Value(published),
      sortCursor: Value(sortCursor),
    );
  }

  factory ProductRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductRow(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      salesMode: serializer.fromJson<String>(json['salesMode']),
      priceMinor: serializer.fromJson<int?>(json['priceMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      specs: serializer.fromJson<String>(json['specs']),
      imageHint: serializer.fromJson<String>(json['imageHint']),
      published: serializer.fromJson<bool>(json['published']),
      sortCursor: serializer.fromJson<String>(json['sortCursor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryId': serializer.toJson<String>(categoryId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'salesMode': serializer.toJson<String>(salesMode),
      'priceMinor': serializer.toJson<int?>(priceMinor),
      'currency': serializer.toJson<String>(currency),
      'specs': serializer.toJson<String>(specs),
      'imageHint': serializer.toJson<String>(imageHint),
      'published': serializer.toJson<bool>(published),
      'sortCursor': serializer.toJson<String>(sortCursor),
    };
  }

  ProductRow copyWith({
    String? id,
    String? categoryId,
    String? name,
    String? description,
    String? salesMode,
    Value<int?> priceMinor = const Value.absent(),
    String? currency,
    String? specs,
    String? imageHint,
    bool? published,
    String? sortCursor,
  }) => ProductRow(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    name: name ?? this.name,
    description: description ?? this.description,
    salesMode: salesMode ?? this.salesMode,
    priceMinor: priceMinor.present ? priceMinor.value : this.priceMinor,
    currency: currency ?? this.currency,
    specs: specs ?? this.specs,
    imageHint: imageHint ?? this.imageHint,
    published: published ?? this.published,
    sortCursor: sortCursor ?? this.sortCursor,
  );
  ProductRow copyWithCompanion(ProductsCompanion data) {
    return ProductRow(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      salesMode: data.salesMode.present ? data.salesMode.value : this.salesMode,
      priceMinor: data.priceMinor.present
          ? data.priceMinor.value
          : this.priceMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      specs: data.specs.present ? data.specs.value : this.specs,
      imageHint: data.imageHint.present ? data.imageHint.value : this.imageHint,
      published: data.published.present ? data.published.value : this.published,
      sortCursor: data.sortCursor.present
          ? data.sortCursor.value
          : this.sortCursor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductRow(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('salesMode: $salesMode, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('currency: $currency, ')
          ..write('specs: $specs, ')
          ..write('imageHint: $imageHint, ')
          ..write('published: $published, ')
          ..write('sortCursor: $sortCursor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryId,
    name,
    description,
    salesMode,
    priceMinor,
    currency,
    specs,
    imageHint,
    published,
    sortCursor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductRow &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.description == this.description &&
          other.salesMode == this.salesMode &&
          other.priceMinor == this.priceMinor &&
          other.currency == this.currency &&
          other.specs == this.specs &&
          other.imageHint == this.imageHint &&
          other.published == this.published &&
          other.sortCursor == this.sortCursor);
}

class ProductsCompanion extends UpdateCompanion<ProductRow> {
  final Value<String> id;
  final Value<String> categoryId;
  final Value<String> name;
  final Value<String> description;
  final Value<String> salesMode;
  final Value<int?> priceMinor;
  final Value<String> currency;
  final Value<String> specs;
  final Value<String> imageHint;
  final Value<bool> published;
  final Value<String> sortCursor;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.salesMode = const Value.absent(),
    this.priceMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.specs = const Value.absent(),
    this.imageHint = const Value.absent(),
    this.published = const Value.absent(),
    this.sortCursor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String categoryId,
    required String name,
    required String description,
    required String salesMode,
    this.priceMinor = const Value.absent(),
    this.currency = const Value.absent(),
    required String specs,
    required String imageHint,
    this.published = const Value.absent(),
    required String sortCursor,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       categoryId = Value(categoryId),
       name = Value(name),
       description = Value(description),
       salesMode = Value(salesMode),
       specs = Value(specs),
       imageHint = Value(imageHint),
       sortCursor = Value(sortCursor);
  static Insertable<ProductRow> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? salesMode,
    Expression<int>? priceMinor,
    Expression<String>? currency,
    Expression<String>? specs,
    Expression<String>? imageHint,
    Expression<bool>? published,
    Expression<String>? sortCursor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (salesMode != null) 'sales_mode': salesMode,
      if (priceMinor != null) 'price_minor': priceMinor,
      if (currency != null) 'currency': currency,
      if (specs != null) 'specs': specs,
      if (imageHint != null) 'image_hint': imageHint,
      if (published != null) 'published': published,
      if (sortCursor != null) 'sort_cursor': sortCursor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? categoryId,
    Value<String>? name,
    Value<String>? description,
    Value<String>? salesMode,
    Value<int?>? priceMinor,
    Value<String>? currency,
    Value<String>? specs,
    Value<String>? imageHint,
    Value<bool>? published,
    Value<String>? sortCursor,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      salesMode: salesMode ?? this.salesMode,
      priceMinor: priceMinor ?? this.priceMinor,
      currency: currency ?? this.currency,
      specs: specs ?? this.specs,
      imageHint: imageHint ?? this.imageHint,
      published: published ?? this.published,
      sortCursor: sortCursor ?? this.sortCursor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (salesMode.present) {
      map['sales_mode'] = Variable<String>(salesMode.value);
    }
    if (priceMinor.present) {
      map['price_minor'] = Variable<int>(priceMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (specs.present) {
      map['specs'] = Variable<String>(specs.value);
    }
    if (imageHint.present) {
      map['image_hint'] = Variable<String>(imageHint.value);
    }
    if (published.present) {
      map['published'] = Variable<bool>(published.value);
    }
    if (sortCursor.present) {
      map['sort_cursor'] = Variable<String>(sortCursor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('salesMode: $salesMode, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('currency: $currency, ')
          ..write('specs: $specs, ')
          ..write('imageHint: $imageHint, ')
          ..write('published: $published, ')
          ..write('sortCursor: $sortCursor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CartsTable extends Carts with TableInfo<$CartsTable, CartRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _totalMinorMeta = const VerificationMeta(
    'totalMinor',
  );
  @override
  late final GeneratedColumn<int> totalMinor = GeneratedColumn<int>(
    'total_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    totalMinor,
    currency,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'carts';
  @override
  VerificationContext validateIntegrity(
    Insertable<CartRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('total_minor')) {
      context.handle(
        _totalMinorMeta,
        totalMinor.isAcceptableOrUnknown(data['total_minor']!, _totalMinorMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CartRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CartRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      ),
      totalMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $CartsTable createAlias(String alias) {
    return $CartsTable(attachedDatabase, alias);
  }
}

class CartRow extends DataClass implements Insertable<CartRow> {
  final String id;
  final String? accountId;
  final int totalMinor;
  final String currency;
  final int version;
  const CartRow({
    required this.id,
    this.accountId,
    required this.totalMinor,
    required this.currency,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    map['total_minor'] = Variable<int>(totalMinor);
    map['currency'] = Variable<String>(currency);
    map['version'] = Variable<int>(version);
    return map;
  }

  CartsCompanion toCompanion(bool nullToAbsent) {
    return CartsCompanion(
      id: Value(id),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      totalMinor: Value(totalMinor),
      currency: Value(currency),
      version: Value(version),
    );
  }

  factory CartRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CartRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      totalMinor: serializer.fromJson<int>(json['totalMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String?>(accountId),
      'totalMinor': serializer.toJson<int>(totalMinor),
      'currency': serializer.toJson<String>(currency),
      'version': serializer.toJson<int>(version),
    };
  }

  CartRow copyWith({
    String? id,
    Value<String?> accountId = const Value.absent(),
    int? totalMinor,
    String? currency,
    int? version,
  }) => CartRow(
    id: id ?? this.id,
    accountId: accountId.present ? accountId.value : this.accountId,
    totalMinor: totalMinor ?? this.totalMinor,
    currency: currency ?? this.currency,
    version: version ?? this.version,
  );
  CartRow copyWithCompanion(CartsCompanion data) {
    return CartRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      totalMinor: data.totalMinor.present
          ? data.totalMinor.value
          : this.totalMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CartRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('totalMinor: $totalMinor, ')
          ..write('currency: $currency, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, totalMinor, currency, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.totalMinor == this.totalMinor &&
          other.currency == this.currency &&
          other.version == this.version);
}

class CartsCompanion extends UpdateCompanion<CartRow> {
  final Value<String> id;
  final Value<String?> accountId;
  final Value<int> totalMinor;
  final Value<String> currency;
  final Value<int> version;
  final Value<int> rowid;
  const CartsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.totalMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CartsCompanion.insert({
    required String id,
    this.accountId = const Value.absent(),
    required int totalMinor,
    this.currency = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       totalMinor = Value(totalMinor);
  static Insertable<CartRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<int>? totalMinor,
    Expression<String>? currency,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (totalMinor != null) 'total_minor': totalMinor,
      if (currency != null) 'currency': currency,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CartsCompanion copyWith({
    Value<String>? id,
    Value<String?>? accountId,
    Value<int>? totalMinor,
    Value<String>? currency,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return CartsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      totalMinor: totalMinor ?? this.totalMinor,
      currency: currency ?? this.currency,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (totalMinor.present) {
      map['total_minor'] = Variable<int>(totalMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('totalMinor: $totalMinor, ')
          ..write('currency: $currency, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CartItemsTable extends CartItems
    with TableInfo<$CartItemsTable, CartItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cartIdMeta = const VerificationMeta('cartId');
  @override
  late final GeneratedColumn<String> cartId = GeneratedColumn<String>(
    'cart_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES carts (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _nameSnapshotMeta = const VerificationMeta(
    'nameSnapshot',
  );
  @override
  late final GeneratedColumn<String> nameSnapshot = GeneratedColumn<String>(
    'name_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMinorMeta = const VerificationMeta(
    'unitPriceMinor',
  );
  @override
  late final GeneratedColumn<int> unitPriceMinor = GeneratedColumn<int>(
    'unit_price_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unavailableMeta = const VerificationMeta(
    'unavailable',
  );
  @override
  late final GeneratedColumn<bool> unavailable = GeneratedColumn<bool>(
    'unavailable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("unavailable" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _repricedMeta = const VerificationMeta(
    'repriced',
  );
  @override
  late final GeneratedColumn<bool> repriced = GeneratedColumn<bool>(
    'repriced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("repriced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cartId,
    productId,
    nameSnapshot,
    unitPriceMinor,
    currency,
    quantity,
    unavailable,
    repriced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cart_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CartItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cart_id')) {
      context.handle(
        _cartIdMeta,
        cartId.isAcceptableOrUnknown(data['cart_id']!, _cartIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cartIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('name_snapshot')) {
      context.handle(
        _nameSnapshotMeta,
        nameSnapshot.isAcceptableOrUnknown(
          data['name_snapshot']!,
          _nameSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameSnapshotMeta);
    }
    if (data.containsKey('unit_price_minor')) {
      context.handle(
        _unitPriceMinorMeta,
        unitPriceMinor.isAcceptableOrUnknown(
          data['unit_price_minor']!,
          _unitPriceMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unavailable')) {
      context.handle(
        _unavailableMeta,
        unavailable.isAcceptableOrUnknown(
          data['unavailable']!,
          _unavailableMeta,
        ),
      );
    }
    if (data.containsKey('repriced')) {
      context.handle(
        _repricedMeta,
        repriced.isAcceptableOrUnknown(data['repriced']!, _repricedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CartItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CartItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cartId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cart_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      nameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_snapshot'],
      )!,
      unitPriceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unavailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}unavailable'],
      )!,
      repriced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}repriced'],
      )!,
    );
  }

  @override
  $CartItemsTable createAlias(String alias) {
    return $CartItemsTable(attachedDatabase, alias);
  }
}

class CartItemRow extends DataClass implements Insertable<CartItemRow> {
  final String id;
  final String cartId;
  final String productId;
  final String nameSnapshot;
  final int unitPriceMinor;
  final String currency;
  final int quantity;
  final bool unavailable;
  final bool repriced;
  const CartItemRow({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.nameSnapshot,
    required this.unitPriceMinor,
    required this.currency,
    required this.quantity,
    required this.unavailable,
    required this.repriced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cart_id'] = Variable<String>(cartId);
    map['product_id'] = Variable<String>(productId);
    map['name_snapshot'] = Variable<String>(nameSnapshot);
    map['unit_price_minor'] = Variable<int>(unitPriceMinor);
    map['currency'] = Variable<String>(currency);
    map['quantity'] = Variable<int>(quantity);
    map['unavailable'] = Variable<bool>(unavailable);
    map['repriced'] = Variable<bool>(repriced);
    return map;
  }

  CartItemsCompanion toCompanion(bool nullToAbsent) {
    return CartItemsCompanion(
      id: Value(id),
      cartId: Value(cartId),
      productId: Value(productId),
      nameSnapshot: Value(nameSnapshot),
      unitPriceMinor: Value(unitPriceMinor),
      currency: Value(currency),
      quantity: Value(quantity),
      unavailable: Value(unavailable),
      repriced: Value(repriced),
    );
  }

  factory CartItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CartItemRow(
      id: serializer.fromJson<String>(json['id']),
      cartId: serializer.fromJson<String>(json['cartId']),
      productId: serializer.fromJson<String>(json['productId']),
      nameSnapshot: serializer.fromJson<String>(json['nameSnapshot']),
      unitPriceMinor: serializer.fromJson<int>(json['unitPriceMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unavailable: serializer.fromJson<bool>(json['unavailable']),
      repriced: serializer.fromJson<bool>(json['repriced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cartId': serializer.toJson<String>(cartId),
      'productId': serializer.toJson<String>(productId),
      'nameSnapshot': serializer.toJson<String>(nameSnapshot),
      'unitPriceMinor': serializer.toJson<int>(unitPriceMinor),
      'currency': serializer.toJson<String>(currency),
      'quantity': serializer.toJson<int>(quantity),
      'unavailable': serializer.toJson<bool>(unavailable),
      'repriced': serializer.toJson<bool>(repriced),
    };
  }

  CartItemRow copyWith({
    String? id,
    String? cartId,
    String? productId,
    String? nameSnapshot,
    int? unitPriceMinor,
    String? currency,
    int? quantity,
    bool? unavailable,
    bool? repriced,
  }) => CartItemRow(
    id: id ?? this.id,
    cartId: cartId ?? this.cartId,
    productId: productId ?? this.productId,
    nameSnapshot: nameSnapshot ?? this.nameSnapshot,
    unitPriceMinor: unitPriceMinor ?? this.unitPriceMinor,
    currency: currency ?? this.currency,
    quantity: quantity ?? this.quantity,
    unavailable: unavailable ?? this.unavailable,
    repriced: repriced ?? this.repriced,
  );
  CartItemRow copyWithCompanion(CartItemsCompanion data) {
    return CartItemRow(
      id: data.id.present ? data.id.value : this.id,
      cartId: data.cartId.present ? data.cartId.value : this.cartId,
      productId: data.productId.present ? data.productId.value : this.productId,
      nameSnapshot: data.nameSnapshot.present
          ? data.nameSnapshot.value
          : this.nameSnapshot,
      unitPriceMinor: data.unitPriceMinor.present
          ? data.unitPriceMinor.value
          : this.unitPriceMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unavailable: data.unavailable.present
          ? data.unavailable.value
          : this.unavailable,
      repriced: data.repriced.present ? data.repriced.value : this.repriced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CartItemRow(')
          ..write('id: $id, ')
          ..write('cartId: $cartId, ')
          ..write('productId: $productId, ')
          ..write('nameSnapshot: $nameSnapshot, ')
          ..write('unitPriceMinor: $unitPriceMinor, ')
          ..write('currency: $currency, ')
          ..write('quantity: $quantity, ')
          ..write('unavailable: $unavailable, ')
          ..write('repriced: $repriced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cartId,
    productId,
    nameSnapshot,
    unitPriceMinor,
    currency,
    quantity,
    unavailable,
    repriced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartItemRow &&
          other.id == this.id &&
          other.cartId == this.cartId &&
          other.productId == this.productId &&
          other.nameSnapshot == this.nameSnapshot &&
          other.unitPriceMinor == this.unitPriceMinor &&
          other.currency == this.currency &&
          other.quantity == this.quantity &&
          other.unavailable == this.unavailable &&
          other.repriced == this.repriced);
}

class CartItemsCompanion extends UpdateCompanion<CartItemRow> {
  final Value<String> id;
  final Value<String> cartId;
  final Value<String> productId;
  final Value<String> nameSnapshot;
  final Value<int> unitPriceMinor;
  final Value<String> currency;
  final Value<int> quantity;
  final Value<bool> unavailable;
  final Value<bool> repriced;
  final Value<int> rowid;
  const CartItemsCompanion({
    this.id = const Value.absent(),
    this.cartId = const Value.absent(),
    this.productId = const Value.absent(),
    this.nameSnapshot = const Value.absent(),
    this.unitPriceMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unavailable = const Value.absent(),
    this.repriced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CartItemsCompanion.insert({
    required String id,
    required String cartId,
    required String productId,
    required String nameSnapshot,
    required int unitPriceMinor,
    required String currency,
    required int quantity,
    this.unavailable = const Value.absent(),
    this.repriced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cartId = Value(cartId),
       productId = Value(productId),
       nameSnapshot = Value(nameSnapshot),
       unitPriceMinor = Value(unitPriceMinor),
       currency = Value(currency),
       quantity = Value(quantity);
  static Insertable<CartItemRow> custom({
    Expression<String>? id,
    Expression<String>? cartId,
    Expression<String>? productId,
    Expression<String>? nameSnapshot,
    Expression<int>? unitPriceMinor,
    Expression<String>? currency,
    Expression<int>? quantity,
    Expression<bool>? unavailable,
    Expression<bool>? repriced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cartId != null) 'cart_id': cartId,
      if (productId != null) 'product_id': productId,
      if (nameSnapshot != null) 'name_snapshot': nameSnapshot,
      if (unitPriceMinor != null) 'unit_price_minor': unitPriceMinor,
      if (currency != null) 'currency': currency,
      if (quantity != null) 'quantity': quantity,
      if (unavailable != null) 'unavailable': unavailable,
      if (repriced != null) 'repriced': repriced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CartItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? cartId,
    Value<String>? productId,
    Value<String>? nameSnapshot,
    Value<int>? unitPriceMinor,
    Value<String>? currency,
    Value<int>? quantity,
    Value<bool>? unavailable,
    Value<bool>? repriced,
    Value<int>? rowid,
  }) {
    return CartItemsCompanion(
      id: id ?? this.id,
      cartId: cartId ?? this.cartId,
      productId: productId ?? this.productId,
      nameSnapshot: nameSnapshot ?? this.nameSnapshot,
      unitPriceMinor: unitPriceMinor ?? this.unitPriceMinor,
      currency: currency ?? this.currency,
      quantity: quantity ?? this.quantity,
      unavailable: unavailable ?? this.unavailable,
      repriced: repriced ?? this.repriced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cartId.present) {
      map['cart_id'] = Variable<String>(cartId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (nameSnapshot.present) {
      map['name_snapshot'] = Variable<String>(nameSnapshot.value);
    }
    if (unitPriceMinor.present) {
      map['unit_price_minor'] = Variable<int>(unitPriceMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unavailable.present) {
      map['unavailable'] = Variable<bool>(unavailable.value);
    }
    if (repriced.present) {
      map['repriced'] = Variable<bool>(repriced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartItemsCompanion(')
          ..write('id: $id, ')
          ..write('cartId: $cartId, ')
          ..write('productId: $productId, ')
          ..write('nameSnapshot: $nameSnapshot, ')
          ..write('unitPriceMinor: $unitPriceMinor, ')
          ..write('currency: $currency, ')
          ..write('quantity: $quantity, ')
          ..write('unavailable: $unavailable, ')
          ..write('repriced: $repriced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SiteUpdatesTable extends SiteUpdates
    with TableInfo<$SiteUpdatesTable, SiteUpdateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SiteUpdatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _publishedMeta = const VerificationMeta(
    'published',
  );
  @override
  late final GeneratedColumn<bool> published = GeneratedColumn<bool>(
    'published',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("published" IN (0, 1))',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eventAtMeta = const VerificationMeta(
    'eventAt',
  );
  @override
  late final GeneratedColumn<DateTime> eventAt = GeneratedColumn<DateTime>(
    'event_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortCursorMeta = const VerificationMeta(
    'sortCursor',
  );
  @override
  late final GeneratedColumn<String> sortCursor = GeneratedColumn<String>(
    'sort_cursor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    published,
    note,
    eventAt,
    sortCursor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'site_updates';
  @override
  VerificationContext validateIntegrity(
    Insertable<SiteUpdateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('published')) {
      context.handle(
        _publishedMeta,
        published.isAcceptableOrUnknown(data['published']!, _publishedMeta),
      );
    } else if (isInserting) {
      context.missing(_publishedMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('event_at')) {
      context.handle(
        _eventAtMeta,
        eventAt.isAcceptableOrUnknown(data['event_at']!, _eventAtMeta),
      );
    } else if (isInserting) {
      context.missing(_eventAtMeta);
    }
    if (data.containsKey('sort_cursor')) {
      context.handle(
        _sortCursorMeta,
        sortCursor.isAcceptableOrUnknown(data['sort_cursor']!, _sortCursorMeta),
      );
    } else if (isInserting) {
      context.missing(_sortCursorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SiteUpdateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SiteUpdateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      published: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}published'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      eventAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}event_at'],
      )!,
      sortCursor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_cursor'],
      )!,
    );
  }

  @override
  $SiteUpdatesTable createAlias(String alias) {
    return $SiteUpdatesTable(attachedDatabase, alias);
  }
}

class SiteUpdateRow extends DataClass implements Insertable<SiteUpdateRow> {
  final String id;
  final String projectId;
  final bool published;
  final String? note;
  final DateTime eventAt;
  final String sortCursor;
  const SiteUpdateRow({
    required this.id,
    required this.projectId,
    required this.published,
    this.note,
    required this.eventAt,
    required this.sortCursor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['published'] = Variable<bool>(published);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['event_at'] = Variable<DateTime>(eventAt);
    map['sort_cursor'] = Variable<String>(sortCursor);
    return map;
  }

  SiteUpdatesCompanion toCompanion(bool nullToAbsent) {
    return SiteUpdatesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      published: Value(published),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      eventAt: Value(eventAt),
      sortCursor: Value(sortCursor),
    );
  }

  factory SiteUpdateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SiteUpdateRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      published: serializer.fromJson<bool>(json['published']),
      note: serializer.fromJson<String?>(json['note']),
      eventAt: serializer.fromJson<DateTime>(json['eventAt']),
      sortCursor: serializer.fromJson<String>(json['sortCursor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'published': serializer.toJson<bool>(published),
      'note': serializer.toJson<String?>(note),
      'eventAt': serializer.toJson<DateTime>(eventAt),
      'sortCursor': serializer.toJson<String>(sortCursor),
    };
  }

  SiteUpdateRow copyWith({
    String? id,
    String? projectId,
    bool? published,
    Value<String?> note = const Value.absent(),
    DateTime? eventAt,
    String? sortCursor,
  }) => SiteUpdateRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    published: published ?? this.published,
    note: note.present ? note.value : this.note,
    eventAt: eventAt ?? this.eventAt,
    sortCursor: sortCursor ?? this.sortCursor,
  );
  SiteUpdateRow copyWithCompanion(SiteUpdatesCompanion data) {
    return SiteUpdateRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      published: data.published.present ? data.published.value : this.published,
      note: data.note.present ? data.note.value : this.note,
      eventAt: data.eventAt.present ? data.eventAt.value : this.eventAt,
      sortCursor: data.sortCursor.present
          ? data.sortCursor.value
          : this.sortCursor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SiteUpdateRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('published: $published, ')
          ..write('note: $note, ')
          ..write('eventAt: $eventAt, ')
          ..write('sortCursor: $sortCursor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, published, note, eventAt, sortCursor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SiteUpdateRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.published == this.published &&
          other.note == this.note &&
          other.eventAt == this.eventAt &&
          other.sortCursor == this.sortCursor);
}

class SiteUpdatesCompanion extends UpdateCompanion<SiteUpdateRow> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<bool> published;
  final Value<String?> note;
  final Value<DateTime> eventAt;
  final Value<String> sortCursor;
  final Value<int> rowid;
  const SiteUpdatesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.published = const Value.absent(),
    this.note = const Value.absent(),
    this.eventAt = const Value.absent(),
    this.sortCursor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SiteUpdatesCompanion.insert({
    required String id,
    required String projectId,
    required bool published,
    this.note = const Value.absent(),
    required DateTime eventAt,
    required String sortCursor,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       published = Value(published),
       eventAt = Value(eventAt),
       sortCursor = Value(sortCursor);
  static Insertable<SiteUpdateRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<bool>? published,
    Expression<String>? note,
    Expression<DateTime>? eventAt,
    Expression<String>? sortCursor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (published != null) 'published': published,
      if (note != null) 'note': note,
      if (eventAt != null) 'event_at': eventAt,
      if (sortCursor != null) 'sort_cursor': sortCursor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SiteUpdatesCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<bool>? published,
    Value<String?>? note,
    Value<DateTime>? eventAt,
    Value<String>? sortCursor,
    Value<int>? rowid,
  }) {
    return SiteUpdatesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      published: published ?? this.published,
      note: note ?? this.note,
      eventAt: eventAt ?? this.eventAt,
      sortCursor: sortCursor ?? this.sortCursor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (published.present) {
      map['published'] = Variable<bool>(published.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (eventAt.present) {
      map['event_at'] = Variable<DateTime>(eventAt.value);
    }
    if (sortCursor.present) {
      map['sort_cursor'] = Variable<String>(sortCursor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SiteUpdatesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('published: $published, ')
          ..write('note: $note, ')
          ..write('eventAt: $eventAt, ')
          ..write('sortCursor: $sortCursor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetsTable extends Assets with TableInfo<$AssetsTable, AssetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visualHintMeta = const VerificationMeta(
    'visualHint',
  );
  @override
  late final GeneratedColumn<String> visualHint = GeneratedColumn<String>(
    'visual_hint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publishedMeta = const VerificationMeta(
    'published',
  );
  @override
  late final GeneratedColumn<bool> published = GeneratedColumn<bool>(
    'published',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("published" IN (0, 1))',
    ),
  );
  static const VerificationMeta _withdrawnMeta = const VerificationMeta(
    'withdrawn',
  );
  @override
  late final GeneratedColumn<bool> withdrawn = GeneratedColumn<bool>(
    'withdrawn',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("withdrawn" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    visualHint,
    caption,
    published,
    withdrawn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('visual_hint')) {
      context.handle(
        _visualHintMeta,
        visualHint.isAcceptableOrUnknown(data['visual_hint']!, _visualHintMeta),
      );
    } else if (isInserting) {
      context.missing(_visualHintMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('published')) {
      context.handle(
        _publishedMeta,
        published.isAcceptableOrUnknown(data['published']!, _publishedMeta),
      );
    } else if (isInserting) {
      context.missing(_publishedMeta);
    }
    if (data.containsKey('withdrawn')) {
      context.handle(
        _withdrawnMeta,
        withdrawn.isAcceptableOrUnknown(data['withdrawn']!, _withdrawnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      visualHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visual_hint'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      published: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}published'],
      )!,
      withdrawn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}withdrawn'],
      )!,
    );
  }

  @override
  $AssetsTable createAlias(String alias) {
    return $AssetsTable(attachedDatabase, alias);
  }
}

class AssetRow extends DataClass implements Insertable<AssetRow> {
  final String id;
  final String visualHint;
  final String? caption;
  final bool published;
  final bool withdrawn;
  const AssetRow({
    required this.id,
    required this.visualHint,
    this.caption,
    required this.published,
    required this.withdrawn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['visual_hint'] = Variable<String>(visualHint);
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    map['published'] = Variable<bool>(published);
    map['withdrawn'] = Variable<bool>(withdrawn);
    return map;
  }

  AssetsCompanion toCompanion(bool nullToAbsent) {
    return AssetsCompanion(
      id: Value(id),
      visualHint: Value(visualHint),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      published: Value(published),
      withdrawn: Value(withdrawn),
    );
  }

  factory AssetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetRow(
      id: serializer.fromJson<String>(json['id']),
      visualHint: serializer.fromJson<String>(json['visualHint']),
      caption: serializer.fromJson<String?>(json['caption']),
      published: serializer.fromJson<bool>(json['published']),
      withdrawn: serializer.fromJson<bool>(json['withdrawn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'visualHint': serializer.toJson<String>(visualHint),
      'caption': serializer.toJson<String?>(caption),
      'published': serializer.toJson<bool>(published),
      'withdrawn': serializer.toJson<bool>(withdrawn),
    };
  }

  AssetRow copyWith({
    String? id,
    String? visualHint,
    Value<String?> caption = const Value.absent(),
    bool? published,
    bool? withdrawn,
  }) => AssetRow(
    id: id ?? this.id,
    visualHint: visualHint ?? this.visualHint,
    caption: caption.present ? caption.value : this.caption,
    published: published ?? this.published,
    withdrawn: withdrawn ?? this.withdrawn,
  );
  AssetRow copyWithCompanion(AssetsCompanion data) {
    return AssetRow(
      id: data.id.present ? data.id.value : this.id,
      visualHint: data.visualHint.present
          ? data.visualHint.value
          : this.visualHint,
      caption: data.caption.present ? data.caption.value : this.caption,
      published: data.published.present ? data.published.value : this.published,
      withdrawn: data.withdrawn.present ? data.withdrawn.value : this.withdrawn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetRow(')
          ..write('id: $id, ')
          ..write('visualHint: $visualHint, ')
          ..write('caption: $caption, ')
          ..write('published: $published, ')
          ..write('withdrawn: $withdrawn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, visualHint, caption, published, withdrawn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetRow &&
          other.id == this.id &&
          other.visualHint == this.visualHint &&
          other.caption == this.caption &&
          other.published == this.published &&
          other.withdrawn == this.withdrawn);
}

class AssetsCompanion extends UpdateCompanion<AssetRow> {
  final Value<String> id;
  final Value<String> visualHint;
  final Value<String?> caption;
  final Value<bool> published;
  final Value<bool> withdrawn;
  final Value<int> rowid;
  const AssetsCompanion({
    this.id = const Value.absent(),
    this.visualHint = const Value.absent(),
    this.caption = const Value.absent(),
    this.published = const Value.absent(),
    this.withdrawn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetsCompanion.insert({
    required String id,
    required String visualHint,
    this.caption = const Value.absent(),
    required bool published,
    this.withdrawn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       visualHint = Value(visualHint),
       published = Value(published);
  static Insertable<AssetRow> custom({
    Expression<String>? id,
    Expression<String>? visualHint,
    Expression<String>? caption,
    Expression<bool>? published,
    Expression<bool>? withdrawn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (visualHint != null) 'visual_hint': visualHint,
      if (caption != null) 'caption': caption,
      if (published != null) 'published': published,
      if (withdrawn != null) 'withdrawn': withdrawn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetsCompanion copyWith({
    Value<String>? id,
    Value<String>? visualHint,
    Value<String?>? caption,
    Value<bool>? published,
    Value<bool>? withdrawn,
    Value<int>? rowid,
  }) {
    return AssetsCompanion(
      id: id ?? this.id,
      visualHint: visualHint ?? this.visualHint,
      caption: caption ?? this.caption,
      published: published ?? this.published,
      withdrawn: withdrawn ?? this.withdrawn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (visualHint.present) {
      map['visual_hint'] = Variable<String>(visualHint.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (published.present) {
      map['published'] = Variable<bool>(published.value);
    }
    if (withdrawn.present) {
      map['withdrawn'] = Variable<bool>(withdrawn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetsCompanion(')
          ..write('id: $id, ')
          ..write('visualHint: $visualHint, ')
          ..write('caption: $caption, ')
          ..write('published: $published, ')
          ..write('withdrawn: $withdrawn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SiteUpdateAssetsTable extends SiteUpdateAssets
    with TableInfo<$SiteUpdateAssetsTable, SiteUpdateAssetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SiteUpdateAssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _updateIdMeta = const VerificationMeta(
    'updateId',
  );
  @override
  late final GeneratedColumn<String> updateId = GeneratedColumn<String>(
    'update_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES site_updates (id)',
    ),
  );
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES assets (id)',
    ),
  );
  static const VerificationMeta _sortIndexMeta = const VerificationMeta(
    'sortIndex',
  );
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
    'sort_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [updateId, assetId, sortIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'site_update_assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<SiteUpdateAssetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('update_id')) {
      context.handle(
        _updateIdMeta,
        updateId.isAcceptableOrUnknown(data['update_id']!, _updateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_updateIdMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('sort_index')) {
      context.handle(
        _sortIndexMeta,
        sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_sortIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {updateId, assetId};
  @override
  SiteUpdateAssetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SiteUpdateAssetRow(
      updateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}update_id'],
      )!,
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      )!,
      sortIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_index'],
      )!,
    );
  }

  @override
  $SiteUpdateAssetsTable createAlias(String alias) {
    return $SiteUpdateAssetsTable(attachedDatabase, alias);
  }
}

class SiteUpdateAssetRow extends DataClass
    implements Insertable<SiteUpdateAssetRow> {
  final String updateId;
  final String assetId;
  final int sortIndex;
  const SiteUpdateAssetRow({
    required this.updateId,
    required this.assetId,
    required this.sortIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['update_id'] = Variable<String>(updateId);
    map['asset_id'] = Variable<String>(assetId);
    map['sort_index'] = Variable<int>(sortIndex);
    return map;
  }

  SiteUpdateAssetsCompanion toCompanion(bool nullToAbsent) {
    return SiteUpdateAssetsCompanion(
      updateId: Value(updateId),
      assetId: Value(assetId),
      sortIndex: Value(sortIndex),
    );
  }

  factory SiteUpdateAssetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SiteUpdateAssetRow(
      updateId: serializer.fromJson<String>(json['updateId']),
      assetId: serializer.fromJson<String>(json['assetId']),
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'updateId': serializer.toJson<String>(updateId),
      'assetId': serializer.toJson<String>(assetId),
      'sortIndex': serializer.toJson<int>(sortIndex),
    };
  }

  SiteUpdateAssetRow copyWith({
    String? updateId,
    String? assetId,
    int? sortIndex,
  }) => SiteUpdateAssetRow(
    updateId: updateId ?? this.updateId,
    assetId: assetId ?? this.assetId,
    sortIndex: sortIndex ?? this.sortIndex,
  );
  SiteUpdateAssetRow copyWithCompanion(SiteUpdateAssetsCompanion data) {
    return SiteUpdateAssetRow(
      updateId: data.updateId.present ? data.updateId.value : this.updateId,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SiteUpdateAssetRow(')
          ..write('updateId: $updateId, ')
          ..write('assetId: $assetId, ')
          ..write('sortIndex: $sortIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(updateId, assetId, sortIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SiteUpdateAssetRow &&
          other.updateId == this.updateId &&
          other.assetId == this.assetId &&
          other.sortIndex == this.sortIndex);
}

class SiteUpdateAssetsCompanion extends UpdateCompanion<SiteUpdateAssetRow> {
  final Value<String> updateId;
  final Value<String> assetId;
  final Value<int> sortIndex;
  final Value<int> rowid;
  const SiteUpdateAssetsCompanion({
    this.updateId = const Value.absent(),
    this.assetId = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SiteUpdateAssetsCompanion.insert({
    required String updateId,
    required String assetId,
    required int sortIndex,
    this.rowid = const Value.absent(),
  }) : updateId = Value(updateId),
       assetId = Value(assetId),
       sortIndex = Value(sortIndex);
  static Insertable<SiteUpdateAssetRow> custom({
    Expression<String>? updateId,
    Expression<String>? assetId,
    Expression<int>? sortIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (updateId != null) 'update_id': updateId,
      if (assetId != null) 'asset_id': assetId,
      if (sortIndex != null) 'sort_index': sortIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SiteUpdateAssetsCompanion copyWith({
    Value<String>? updateId,
    Value<String>? assetId,
    Value<int>? sortIndex,
    Value<int>? rowid,
  }) {
    return SiteUpdateAssetsCompanion(
      updateId: updateId ?? this.updateId,
      assetId: assetId ?? this.assetId,
      sortIndex: sortIndex ?? this.sortIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (updateId.present) {
      map['update_id'] = Variable<String>(updateId.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SiteUpdateAssetsCompanion(')
          ..write('updateId: $updateId, ')
          ..write('assetId: $assetId, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectBalancesTable extends ProjectBalances
    with TableInfo<$ProjectBalancesTable, ProjectBalanceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectBalancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _asOfMeta = const VerificationMeta('asOf');
  @override
  late final GeneratedColumn<DateTime> asOf = GeneratedColumn<DateTime>(
    'as_of',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalContractMinorMeta =
      const VerificationMeta('totalContractMinor');
  @override
  late final GeneratedColumn<int> totalContractMinor = GeneratedColumn<int>(
    'total_contract_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _approvedVariationsMinorMeta =
      const VerificationMeta('approvedVariationsMinor');
  @override
  late final GeneratedColumn<int> approvedVariationsMinor =
      GeneratedColumn<int>(
        'approved_variations_minor',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _netReceivedMinorMeta = const VerificationMeta(
    'netReceivedMinor',
  );
  @override
  late final GeneratedColumn<int> netReceivedMinor = GeneratedColumn<int>(
    'net_received_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outstandingTotalMinorMeta =
      const VerificationMeta('outstandingTotalMinor');
  @override
  late final GeneratedColumn<int> outstandingTotalMinor = GeneratedColumn<int>(
    'outstanding_total_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCurrentlyDueMinorMeta =
      const VerificationMeta('amountCurrentlyDueMinor');
  @override
  late final GeneratedColumn<int> amountCurrentlyDueMinor =
      GeneratedColumn<int>(
        'amount_currently_due_minor',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _creditOverpaymentMinorMeta =
      const VerificationMeta('creditOverpaymentMinor');
  @override
  late final GeneratedColumn<int> creditOverpaymentMinor = GeneratedColumn<int>(
    'credit_overpayment_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    projectId,
    currency,
    asOf,
    totalContractMinor,
    approvedVariationsMinor,
    netReceivedMinor,
    outstandingTotalMinor,
    amountCurrentlyDueMinor,
    creditOverpaymentMinor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_balances';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectBalanceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('as_of')) {
      context.handle(
        _asOfMeta,
        asOf.isAcceptableOrUnknown(data['as_of']!, _asOfMeta),
      );
    } else if (isInserting) {
      context.missing(_asOfMeta);
    }
    if (data.containsKey('total_contract_minor')) {
      context.handle(
        _totalContractMinorMeta,
        totalContractMinor.isAcceptableOrUnknown(
          data['total_contract_minor']!,
          _totalContractMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalContractMinorMeta);
    }
    if (data.containsKey('approved_variations_minor')) {
      context.handle(
        _approvedVariationsMinorMeta,
        approvedVariationsMinor.isAcceptableOrUnknown(
          data['approved_variations_minor']!,
          _approvedVariationsMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_approvedVariationsMinorMeta);
    }
    if (data.containsKey('net_received_minor')) {
      context.handle(
        _netReceivedMinorMeta,
        netReceivedMinor.isAcceptableOrUnknown(
          data['net_received_minor']!,
          _netReceivedMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_netReceivedMinorMeta);
    }
    if (data.containsKey('outstanding_total_minor')) {
      context.handle(
        _outstandingTotalMinorMeta,
        outstandingTotalMinor.isAcceptableOrUnknown(
          data['outstanding_total_minor']!,
          _outstandingTotalMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_outstandingTotalMinorMeta);
    }
    if (data.containsKey('amount_currently_due_minor')) {
      context.handle(
        _amountCurrentlyDueMinorMeta,
        amountCurrentlyDueMinor.isAcceptableOrUnknown(
          data['amount_currently_due_minor']!,
          _amountCurrentlyDueMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCurrentlyDueMinorMeta);
    }
    if (data.containsKey('credit_overpayment_minor')) {
      context.handle(
        _creditOverpaymentMinorMeta,
        creditOverpaymentMinor.isAcceptableOrUnknown(
          data['credit_overpayment_minor']!,
          _creditOverpaymentMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creditOverpaymentMinorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {projectId};
  @override
  ProjectBalanceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectBalanceRow(
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      asOf: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}as_of'],
      )!,
      totalContractMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_contract_minor'],
      )!,
      approvedVariationsMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}approved_variations_minor'],
      )!,
      netReceivedMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}net_received_minor'],
      )!,
      outstandingTotalMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}outstanding_total_minor'],
      )!,
      amountCurrentlyDueMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_currently_due_minor'],
      )!,
      creditOverpaymentMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_overpayment_minor'],
      )!,
    );
  }

  @override
  $ProjectBalancesTable createAlias(String alias) {
    return $ProjectBalancesTable(attachedDatabase, alias);
  }
}

class ProjectBalanceRow extends DataClass
    implements Insertable<ProjectBalanceRow> {
  final String projectId;
  final String currency;
  final DateTime asOf;
  final int totalContractMinor;
  final int approvedVariationsMinor;
  final int netReceivedMinor;
  final int outstandingTotalMinor;
  final int amountCurrentlyDueMinor;
  final int creditOverpaymentMinor;
  const ProjectBalanceRow({
    required this.projectId,
    required this.currency,
    required this.asOf,
    required this.totalContractMinor,
    required this.approvedVariationsMinor,
    required this.netReceivedMinor,
    required this.outstandingTotalMinor,
    required this.amountCurrentlyDueMinor,
    required this.creditOverpaymentMinor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['project_id'] = Variable<String>(projectId);
    map['currency'] = Variable<String>(currency);
    map['as_of'] = Variable<DateTime>(asOf);
    map['total_contract_minor'] = Variable<int>(totalContractMinor);
    map['approved_variations_minor'] = Variable<int>(approvedVariationsMinor);
    map['net_received_minor'] = Variable<int>(netReceivedMinor);
    map['outstanding_total_minor'] = Variable<int>(outstandingTotalMinor);
    map['amount_currently_due_minor'] = Variable<int>(amountCurrentlyDueMinor);
    map['credit_overpayment_minor'] = Variable<int>(creditOverpaymentMinor);
    return map;
  }

  ProjectBalancesCompanion toCompanion(bool nullToAbsent) {
    return ProjectBalancesCompanion(
      projectId: Value(projectId),
      currency: Value(currency),
      asOf: Value(asOf),
      totalContractMinor: Value(totalContractMinor),
      approvedVariationsMinor: Value(approvedVariationsMinor),
      netReceivedMinor: Value(netReceivedMinor),
      outstandingTotalMinor: Value(outstandingTotalMinor),
      amountCurrentlyDueMinor: Value(amountCurrentlyDueMinor),
      creditOverpaymentMinor: Value(creditOverpaymentMinor),
    );
  }

  factory ProjectBalanceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectBalanceRow(
      projectId: serializer.fromJson<String>(json['projectId']),
      currency: serializer.fromJson<String>(json['currency']),
      asOf: serializer.fromJson<DateTime>(json['asOf']),
      totalContractMinor: serializer.fromJson<int>(json['totalContractMinor']),
      approvedVariationsMinor: serializer.fromJson<int>(
        json['approvedVariationsMinor'],
      ),
      netReceivedMinor: serializer.fromJson<int>(json['netReceivedMinor']),
      outstandingTotalMinor: serializer.fromJson<int>(
        json['outstandingTotalMinor'],
      ),
      amountCurrentlyDueMinor: serializer.fromJson<int>(
        json['amountCurrentlyDueMinor'],
      ),
      creditOverpaymentMinor: serializer.fromJson<int>(
        json['creditOverpaymentMinor'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'projectId': serializer.toJson<String>(projectId),
      'currency': serializer.toJson<String>(currency),
      'asOf': serializer.toJson<DateTime>(asOf),
      'totalContractMinor': serializer.toJson<int>(totalContractMinor),
      'approvedVariationsMinor': serializer.toJson<int>(
        approvedVariationsMinor,
      ),
      'netReceivedMinor': serializer.toJson<int>(netReceivedMinor),
      'outstandingTotalMinor': serializer.toJson<int>(outstandingTotalMinor),
      'amountCurrentlyDueMinor': serializer.toJson<int>(
        amountCurrentlyDueMinor,
      ),
      'creditOverpaymentMinor': serializer.toJson<int>(creditOverpaymentMinor),
    };
  }

  ProjectBalanceRow copyWith({
    String? projectId,
    String? currency,
    DateTime? asOf,
    int? totalContractMinor,
    int? approvedVariationsMinor,
    int? netReceivedMinor,
    int? outstandingTotalMinor,
    int? amountCurrentlyDueMinor,
    int? creditOverpaymentMinor,
  }) => ProjectBalanceRow(
    projectId: projectId ?? this.projectId,
    currency: currency ?? this.currency,
    asOf: asOf ?? this.asOf,
    totalContractMinor: totalContractMinor ?? this.totalContractMinor,
    approvedVariationsMinor:
        approvedVariationsMinor ?? this.approvedVariationsMinor,
    netReceivedMinor: netReceivedMinor ?? this.netReceivedMinor,
    outstandingTotalMinor: outstandingTotalMinor ?? this.outstandingTotalMinor,
    amountCurrentlyDueMinor:
        amountCurrentlyDueMinor ?? this.amountCurrentlyDueMinor,
    creditOverpaymentMinor:
        creditOverpaymentMinor ?? this.creditOverpaymentMinor,
  );
  ProjectBalanceRow copyWithCompanion(ProjectBalancesCompanion data) {
    return ProjectBalanceRow(
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      currency: data.currency.present ? data.currency.value : this.currency,
      asOf: data.asOf.present ? data.asOf.value : this.asOf,
      totalContractMinor: data.totalContractMinor.present
          ? data.totalContractMinor.value
          : this.totalContractMinor,
      approvedVariationsMinor: data.approvedVariationsMinor.present
          ? data.approvedVariationsMinor.value
          : this.approvedVariationsMinor,
      netReceivedMinor: data.netReceivedMinor.present
          ? data.netReceivedMinor.value
          : this.netReceivedMinor,
      outstandingTotalMinor: data.outstandingTotalMinor.present
          ? data.outstandingTotalMinor.value
          : this.outstandingTotalMinor,
      amountCurrentlyDueMinor: data.amountCurrentlyDueMinor.present
          ? data.amountCurrentlyDueMinor.value
          : this.amountCurrentlyDueMinor,
      creditOverpaymentMinor: data.creditOverpaymentMinor.present
          ? data.creditOverpaymentMinor.value
          : this.creditOverpaymentMinor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectBalanceRow(')
          ..write('projectId: $projectId, ')
          ..write('currency: $currency, ')
          ..write('asOf: $asOf, ')
          ..write('totalContractMinor: $totalContractMinor, ')
          ..write('approvedVariationsMinor: $approvedVariationsMinor, ')
          ..write('netReceivedMinor: $netReceivedMinor, ')
          ..write('outstandingTotalMinor: $outstandingTotalMinor, ')
          ..write('amountCurrentlyDueMinor: $amountCurrentlyDueMinor, ')
          ..write('creditOverpaymentMinor: $creditOverpaymentMinor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    projectId,
    currency,
    asOf,
    totalContractMinor,
    approvedVariationsMinor,
    netReceivedMinor,
    outstandingTotalMinor,
    amountCurrentlyDueMinor,
    creditOverpaymentMinor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectBalanceRow &&
          other.projectId == this.projectId &&
          other.currency == this.currency &&
          other.asOf == this.asOf &&
          other.totalContractMinor == this.totalContractMinor &&
          other.approvedVariationsMinor == this.approvedVariationsMinor &&
          other.netReceivedMinor == this.netReceivedMinor &&
          other.outstandingTotalMinor == this.outstandingTotalMinor &&
          other.amountCurrentlyDueMinor == this.amountCurrentlyDueMinor &&
          other.creditOverpaymentMinor == this.creditOverpaymentMinor);
}

class ProjectBalancesCompanion extends UpdateCompanion<ProjectBalanceRow> {
  final Value<String> projectId;
  final Value<String> currency;
  final Value<DateTime> asOf;
  final Value<int> totalContractMinor;
  final Value<int> approvedVariationsMinor;
  final Value<int> netReceivedMinor;
  final Value<int> outstandingTotalMinor;
  final Value<int> amountCurrentlyDueMinor;
  final Value<int> creditOverpaymentMinor;
  final Value<int> rowid;
  const ProjectBalancesCompanion({
    this.projectId = const Value.absent(),
    this.currency = const Value.absent(),
    this.asOf = const Value.absent(),
    this.totalContractMinor = const Value.absent(),
    this.approvedVariationsMinor = const Value.absent(),
    this.netReceivedMinor = const Value.absent(),
    this.outstandingTotalMinor = const Value.absent(),
    this.amountCurrentlyDueMinor = const Value.absent(),
    this.creditOverpaymentMinor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectBalancesCompanion.insert({
    required String projectId,
    required String currency,
    required DateTime asOf,
    required int totalContractMinor,
    required int approvedVariationsMinor,
    required int netReceivedMinor,
    required int outstandingTotalMinor,
    required int amountCurrentlyDueMinor,
    required int creditOverpaymentMinor,
    this.rowid = const Value.absent(),
  }) : projectId = Value(projectId),
       currency = Value(currency),
       asOf = Value(asOf),
       totalContractMinor = Value(totalContractMinor),
       approvedVariationsMinor = Value(approvedVariationsMinor),
       netReceivedMinor = Value(netReceivedMinor),
       outstandingTotalMinor = Value(outstandingTotalMinor),
       amountCurrentlyDueMinor = Value(amountCurrentlyDueMinor),
       creditOverpaymentMinor = Value(creditOverpaymentMinor);
  static Insertable<ProjectBalanceRow> custom({
    Expression<String>? projectId,
    Expression<String>? currency,
    Expression<DateTime>? asOf,
    Expression<int>? totalContractMinor,
    Expression<int>? approvedVariationsMinor,
    Expression<int>? netReceivedMinor,
    Expression<int>? outstandingTotalMinor,
    Expression<int>? amountCurrentlyDueMinor,
    Expression<int>? creditOverpaymentMinor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (projectId != null) 'project_id': projectId,
      if (currency != null) 'currency': currency,
      if (asOf != null) 'as_of': asOf,
      if (totalContractMinor != null)
        'total_contract_minor': totalContractMinor,
      if (approvedVariationsMinor != null)
        'approved_variations_minor': approvedVariationsMinor,
      if (netReceivedMinor != null) 'net_received_minor': netReceivedMinor,
      if (outstandingTotalMinor != null)
        'outstanding_total_minor': outstandingTotalMinor,
      if (amountCurrentlyDueMinor != null)
        'amount_currently_due_minor': amountCurrentlyDueMinor,
      if (creditOverpaymentMinor != null)
        'credit_overpayment_minor': creditOverpaymentMinor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectBalancesCompanion copyWith({
    Value<String>? projectId,
    Value<String>? currency,
    Value<DateTime>? asOf,
    Value<int>? totalContractMinor,
    Value<int>? approvedVariationsMinor,
    Value<int>? netReceivedMinor,
    Value<int>? outstandingTotalMinor,
    Value<int>? amountCurrentlyDueMinor,
    Value<int>? creditOverpaymentMinor,
    Value<int>? rowid,
  }) {
    return ProjectBalancesCompanion(
      projectId: projectId ?? this.projectId,
      currency: currency ?? this.currency,
      asOf: asOf ?? this.asOf,
      totalContractMinor: totalContractMinor ?? this.totalContractMinor,
      approvedVariationsMinor:
          approvedVariationsMinor ?? this.approvedVariationsMinor,
      netReceivedMinor: netReceivedMinor ?? this.netReceivedMinor,
      outstandingTotalMinor:
          outstandingTotalMinor ?? this.outstandingTotalMinor,
      amountCurrentlyDueMinor:
          amountCurrentlyDueMinor ?? this.amountCurrentlyDueMinor,
      creditOverpaymentMinor:
          creditOverpaymentMinor ?? this.creditOverpaymentMinor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (asOf.present) {
      map['as_of'] = Variable<DateTime>(asOf.value);
    }
    if (totalContractMinor.present) {
      map['total_contract_minor'] = Variable<int>(totalContractMinor.value);
    }
    if (approvedVariationsMinor.present) {
      map['approved_variations_minor'] = Variable<int>(
        approvedVariationsMinor.value,
      );
    }
    if (netReceivedMinor.present) {
      map['net_received_minor'] = Variable<int>(netReceivedMinor.value);
    }
    if (outstandingTotalMinor.present) {
      map['outstanding_total_minor'] = Variable<int>(
        outstandingTotalMinor.value,
      );
    }
    if (amountCurrentlyDueMinor.present) {
      map['amount_currently_due_minor'] = Variable<int>(
        amountCurrentlyDueMinor.value,
      );
    }
    if (creditOverpaymentMinor.present) {
      map['credit_overpayment_minor'] = Variable<int>(
        creditOverpaymentMinor.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectBalancesCompanion(')
          ..write('projectId: $projectId, ')
          ..write('currency: $currency, ')
          ..write('asOf: $asOf, ')
          ..write('totalContractMinor: $totalContractMinor, ')
          ..write('approvedVariationsMinor: $approvedVariationsMinor, ')
          ..write('netReceivedMinor: $netReceivedMinor, ')
          ..write('outstandingTotalMinor: $outstandingTotalMinor, ')
          ..write('amountCurrentlyDueMinor: $amountCurrentlyDueMinor, ')
          ..write('creditOverpaymentMinor: $creditOverpaymentMinor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LedgerEntriesTable extends LedgerEntries
    with TableInfo<$LedgerEntriesTable, LedgerEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LedgerEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _postedAtMeta = const VerificationMeta(
    'postedAt',
  );
  @override
  late final GeneratedColumn<DateTime> postedAt = GeneratedColumn<DateTime>(
    'posted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortCursorMeta = const VerificationMeta(
    'sortCursor',
  );
  @override
  late final GeneratedColumn<String> sortCursor = GeneratedColumn<String>(
    'sort_cursor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    description,
    state,
    amountMinor,
    currency,
    postedAt,
    sortCursor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ledger_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LedgerEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('posted_at')) {
      context.handle(
        _postedAtMeta,
        postedAt.isAcceptableOrUnknown(data['posted_at']!, _postedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_postedAtMeta);
    }
    if (data.containsKey('sort_cursor')) {
      context.handle(
        _sortCursorMeta,
        sortCursor.isAcceptableOrUnknown(data['sort_cursor']!, _sortCursorMeta),
      );
    } else if (isInserting) {
      context.missing(_sortCursorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LedgerEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LedgerEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      postedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}posted_at'],
      )!,
      sortCursor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_cursor'],
      )!,
    );
  }

  @override
  $LedgerEntriesTable createAlias(String alias) {
    return $LedgerEntriesTable(attachedDatabase, alias);
  }
}

class LedgerEntryRow extends DataClass implements Insertable<LedgerEntryRow> {
  final String id;
  final String projectId;
  final String description;
  final String state;
  final int amountMinor;
  final String currency;
  final DateTime postedAt;
  final String sortCursor;
  const LedgerEntryRow({
    required this.id,
    required this.projectId,
    required this.description,
    required this.state,
    required this.amountMinor,
    required this.currency,
    required this.postedAt,
    required this.sortCursor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['description'] = Variable<String>(description);
    map['state'] = Variable<String>(state);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    map['posted_at'] = Variable<DateTime>(postedAt);
    map['sort_cursor'] = Variable<String>(sortCursor);
    return map;
  }

  LedgerEntriesCompanion toCompanion(bool nullToAbsent) {
    return LedgerEntriesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      description: Value(description),
      state: Value(state),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      postedAt: Value(postedAt),
      sortCursor: Value(sortCursor),
    );
  }

  factory LedgerEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LedgerEntryRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      description: serializer.fromJson<String>(json['description']),
      state: serializer.fromJson<String>(json['state']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      postedAt: serializer.fromJson<DateTime>(json['postedAt']),
      sortCursor: serializer.fromJson<String>(json['sortCursor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'description': serializer.toJson<String>(description),
      'state': serializer.toJson<String>(state),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'postedAt': serializer.toJson<DateTime>(postedAt),
      'sortCursor': serializer.toJson<String>(sortCursor),
    };
  }

  LedgerEntryRow copyWith({
    String? id,
    String? projectId,
    String? description,
    String? state,
    int? amountMinor,
    String? currency,
    DateTime? postedAt,
    String? sortCursor,
  }) => LedgerEntryRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    description: description ?? this.description,
    state: state ?? this.state,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    postedAt: postedAt ?? this.postedAt,
    sortCursor: sortCursor ?? this.sortCursor,
  );
  LedgerEntryRow copyWithCompanion(LedgerEntriesCompanion data) {
    return LedgerEntryRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      description: data.description.present
          ? data.description.value
          : this.description,
      state: data.state.present ? data.state.value : this.state,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      postedAt: data.postedAt.present ? data.postedAt.value : this.postedAt,
      sortCursor: data.sortCursor.present
          ? data.sortCursor.value
          : this.sortCursor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LedgerEntryRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('description: $description, ')
          ..write('state: $state, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('postedAt: $postedAt, ')
          ..write('sortCursor: $sortCursor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    description,
    state,
    amountMinor,
    currency,
    postedAt,
    sortCursor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LedgerEntryRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.description == this.description &&
          other.state == this.state &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.postedAt == this.postedAt &&
          other.sortCursor == this.sortCursor);
}

class LedgerEntriesCompanion extends UpdateCompanion<LedgerEntryRow> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> description;
  final Value<String> state;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<DateTime> postedAt;
  final Value<String> sortCursor;
  final Value<int> rowid;
  const LedgerEntriesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.description = const Value.absent(),
    this.state = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.postedAt = const Value.absent(),
    this.sortCursor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LedgerEntriesCompanion.insert({
    required String id,
    required String projectId,
    required String description,
    required String state,
    required int amountMinor,
    required String currency,
    required DateTime postedAt,
    required String sortCursor,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       description = Value(description),
       state = Value(state),
       amountMinor = Value(amountMinor),
       currency = Value(currency),
       postedAt = Value(postedAt),
       sortCursor = Value(sortCursor);
  static Insertable<LedgerEntryRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? description,
    Expression<String>? state,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<DateTime>? postedAt,
    Expression<String>? sortCursor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (description != null) 'description': description,
      if (state != null) 'state': state,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (postedAt != null) 'posted_at': postedAt,
      if (sortCursor != null) 'sort_cursor': sortCursor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LedgerEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? description,
    Value<String>? state,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<DateTime>? postedAt,
    Value<String>? sortCursor,
    Value<int>? rowid,
  }) {
    return LedgerEntriesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      description: description ?? this.description,
      state: state ?? this.state,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      postedAt: postedAt ?? this.postedAt,
      sortCursor: sortCursor ?? this.sortCursor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (postedAt.present) {
      map['posted_at'] = Variable<DateTime>(postedAt.value);
    }
    if (sortCursor.present) {
      map['sort_cursor'] = Variable<String>(sortCursor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LedgerEntriesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('description: $description, ')
          ..write('state: $state, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('postedAt: $postedAt, ')
          ..write('sortCursor: $sortCursor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DueScheduleItemsTable extends DueScheduleItems
    with TableInfo<$DueScheduleItemsTable, DueScheduleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DueScheduleItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortIndexMeta = const VerificationMeta(
    'sortIndex',
  );
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
    'sort_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    label,
    amountMinor,
    currency,
    dueAt,
    sortIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'due_schedule_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DueScheduleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('sort_index')) {
      context.handle(
        _sortIndexMeta,
        sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_sortIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DueScheduleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DueScheduleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      )!,
      sortIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_index'],
      )!,
    );
  }

  @override
  $DueScheduleItemsTable createAlias(String alias) {
    return $DueScheduleItemsTable(attachedDatabase, alias);
  }
}

class DueScheduleRow extends DataClass implements Insertable<DueScheduleRow> {
  final String id;
  final String projectId;
  final String label;
  final int amountMinor;
  final String currency;
  final DateTime dueAt;
  final int sortIndex;
  const DueScheduleRow({
    required this.id,
    required this.projectId,
    required this.label,
    required this.amountMinor,
    required this.currency,
    required this.dueAt,
    required this.sortIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['label'] = Variable<String>(label);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    map['due_at'] = Variable<DateTime>(dueAt);
    map['sort_index'] = Variable<int>(sortIndex);
    return map;
  }

  DueScheduleItemsCompanion toCompanion(bool nullToAbsent) {
    return DueScheduleItemsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      label: Value(label),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      dueAt: Value(dueAt),
      sortIndex: Value(sortIndex),
    );
  }

  factory DueScheduleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DueScheduleRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      label: serializer.fromJson<String>(json['label']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'label': serializer.toJson<String>(label),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'sortIndex': serializer.toJson<int>(sortIndex),
    };
  }

  DueScheduleRow copyWith({
    String? id,
    String? projectId,
    String? label,
    int? amountMinor,
    String? currency,
    DateTime? dueAt,
    int? sortIndex,
  }) => DueScheduleRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    label: label ?? this.label,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    dueAt: dueAt ?? this.dueAt,
    sortIndex: sortIndex ?? this.sortIndex,
  );
  DueScheduleRow copyWithCompanion(DueScheduleItemsCompanion data) {
    return DueScheduleRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      label: data.label.present ? data.label.value : this.label,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DueScheduleRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('label: $label, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('dueAt: $dueAt, ')
          ..write('sortIndex: $sortIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    label,
    amountMinor,
    currency,
    dueAt,
    sortIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DueScheduleRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.label == this.label &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.dueAt == this.dueAt &&
          other.sortIndex == this.sortIndex);
}

class DueScheduleItemsCompanion extends UpdateCompanion<DueScheduleRow> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> label;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<DateTime> dueAt;
  final Value<int> sortIndex;
  final Value<int> rowid;
  const DueScheduleItemsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.label = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DueScheduleItemsCompanion.insert({
    required String id,
    required String projectId,
    required String label,
    required int amountMinor,
    required String currency,
    required DateTime dueAt,
    required int sortIndex,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       label = Value(label),
       amountMinor = Value(amountMinor),
       currency = Value(currency),
       dueAt = Value(dueAt),
       sortIndex = Value(sortIndex);
  static Insertable<DueScheduleRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? label,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<DateTime>? dueAt,
    Expression<int>? sortIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (label != null) 'label': label,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (dueAt != null) 'due_at': dueAt,
      if (sortIndex != null) 'sort_index': sortIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DueScheduleItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? label,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<DateTime>? dueAt,
    Value<int>? sortIndex,
    Value<int>? rowid,
  }) {
    return DueScheduleItemsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      label: label ?? this.label,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      dueAt: dueAt ?? this.dueAt,
      sortIndex: sortIndex ?? this.sortIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DueScheduleItemsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('label: $label, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('dueAt: $dueAt, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectDocumentsTable extends ProjectDocuments
    with TableInfo<$ProjectDocumentsTable, ProjectDocumentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES assets (id)',
    ),
  );
  static const VerificationMeta _publishedMeta = const VerificationMeta(
    'published',
  );
  @override
  late final GeneratedColumn<bool> published = GeneratedColumn<bool>(
    'published',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("published" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    type,
    title,
    assetId,
    published,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectDocumentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('published')) {
      context.handle(
        _publishedMeta,
        published.isAcceptableOrUnknown(data['published']!, _publishedMeta),
      );
    } else if (isInserting) {
      context.missing(_publishedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectDocumentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectDocumentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      )!,
      published: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}published'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProjectDocumentsTable createAlias(String alias) {
    return $ProjectDocumentsTable(attachedDatabase, alias);
  }
}

class ProjectDocumentRow extends DataClass
    implements Insertable<ProjectDocumentRow> {
  final String id;
  final String projectId;
  final String type;
  final String title;
  final String assetId;
  final bool published;
  final DateTime createdAt;
  const ProjectDocumentRow({
    required this.id,
    required this.projectId,
    required this.type,
    required this.title,
    required this.assetId,
    required this.published,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    map['asset_id'] = Variable<String>(assetId);
    map['published'] = Variable<bool>(published);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProjectDocumentsCompanion toCompanion(bool nullToAbsent) {
    return ProjectDocumentsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      type: Value(type),
      title: Value(title),
      assetId: Value(assetId),
      published: Value(published),
      createdAt: Value(createdAt),
    );
  }

  factory ProjectDocumentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectDocumentRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      assetId: serializer.fromJson<String>(json['assetId']),
      published: serializer.fromJson<bool>(json['published']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'assetId': serializer.toJson<String>(assetId),
      'published': serializer.toJson<bool>(published),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProjectDocumentRow copyWith({
    String? id,
    String? projectId,
    String? type,
    String? title,
    String? assetId,
    bool? published,
    DateTime? createdAt,
  }) => ProjectDocumentRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    type: type ?? this.type,
    title: title ?? this.title,
    assetId: assetId ?? this.assetId,
    published: published ?? this.published,
    createdAt: createdAt ?? this.createdAt,
  );
  ProjectDocumentRow copyWithCompanion(ProjectDocumentsCompanion data) {
    return ProjectDocumentRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      published: data.published.present ? data.published.value : this.published,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectDocumentRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('assetId: $assetId, ')
          ..write('published: $published, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, type, title, assetId, published, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectDocumentRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.type == this.type &&
          other.title == this.title &&
          other.assetId == this.assetId &&
          other.published == this.published &&
          other.createdAt == this.createdAt);
}

class ProjectDocumentsCompanion extends UpdateCompanion<ProjectDocumentRow> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> type;
  final Value<String> title;
  final Value<String> assetId;
  final Value<bool> published;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProjectDocumentsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.assetId = const Value.absent(),
    this.published = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectDocumentsCompanion.insert({
    required String id,
    required String projectId,
    required String type,
    required String title,
    required String assetId,
    required bool published,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       type = Value(type),
       title = Value(title),
       assetId = Value(assetId),
       published = Value(published),
       createdAt = Value(createdAt);
  static Insertable<ProjectDocumentRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? assetId,
    Expression<bool>? published,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (assetId != null) 'asset_id': assetId,
      if (published != null) 'published': published,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectDocumentsCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? type,
    Value<String>? title,
    Value<String>? assetId,
    Value<bool>? published,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ProjectDocumentsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      type: type ?? this.type,
      title: title ?? this.title,
      assetId: assetId ?? this.assetId,
      published: published ?? this.published,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (published.present) {
      map['published'] = Variable<bool>(published.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('assetId: $assetId, ')
          ..write('published: $published, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DesignsTable extends Designs with TableInfo<$DesignsTable, DesignRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DesignsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionLabelMeta = const VerificationMeta(
    'versionLabel',
  );
  @override
  late final GeneratedColumn<String> versionLabel = GeneratedColumn<String>(
    'version_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _approvedMeta = const VerificationMeta(
    'approved',
  );
  @override
  late final GeneratedColumn<bool> approved = GeneratedColumn<bool>(
    'approved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("approved" IN (0, 1))',
    ),
  );
  static const VerificationMeta _publishedMeta = const VerificationMeta(
    'published',
  );
  @override
  late final GeneratedColumn<bool> published = GeneratedColumn<bool>(
    'published',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("published" IN (0, 1))',
    ),
  );
  static const VerificationMeta _sortIndexMeta = const VerificationMeta(
    'sortIndex',
  );
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
    'sort_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    title,
    versionLabel,
    approved,
    published,
    sortIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'designs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DesignRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('version_label')) {
      context.handle(
        _versionLabelMeta,
        versionLabel.isAcceptableOrUnknown(
          data['version_label']!,
          _versionLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_versionLabelMeta);
    }
    if (data.containsKey('approved')) {
      context.handle(
        _approvedMeta,
        approved.isAcceptableOrUnknown(data['approved']!, _approvedMeta),
      );
    } else if (isInserting) {
      context.missing(_approvedMeta);
    }
    if (data.containsKey('published')) {
      context.handle(
        _publishedMeta,
        published.isAcceptableOrUnknown(data['published']!, _publishedMeta),
      );
    } else if (isInserting) {
      context.missing(_publishedMeta);
    }
    if (data.containsKey('sort_index')) {
      context.handle(
        _sortIndexMeta,
        sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_sortIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DesignRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DesignRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      versionLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version_label'],
      )!,
      approved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}approved'],
      )!,
      published: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}published'],
      )!,
      sortIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_index'],
      )!,
    );
  }

  @override
  $DesignsTable createAlias(String alias) {
    return $DesignsTable(attachedDatabase, alias);
  }
}

class DesignRow extends DataClass implements Insertable<DesignRow> {
  final String id;
  final String projectId;
  final String title;
  final String versionLabel;
  final bool approved;
  final bool published;
  final int sortIndex;
  const DesignRow({
    required this.id,
    required this.projectId,
    required this.title,
    required this.versionLabel,
    required this.approved,
    required this.published,
    required this.sortIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['title'] = Variable<String>(title);
    map['version_label'] = Variable<String>(versionLabel);
    map['approved'] = Variable<bool>(approved);
    map['published'] = Variable<bool>(published);
    map['sort_index'] = Variable<int>(sortIndex);
    return map;
  }

  DesignsCompanion toCompanion(bool nullToAbsent) {
    return DesignsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      title: Value(title),
      versionLabel: Value(versionLabel),
      approved: Value(approved),
      published: Value(published),
      sortIndex: Value(sortIndex),
    );
  }

  factory DesignRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DesignRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      title: serializer.fromJson<String>(json['title']),
      versionLabel: serializer.fromJson<String>(json['versionLabel']),
      approved: serializer.fromJson<bool>(json['approved']),
      published: serializer.fromJson<bool>(json['published']),
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'title': serializer.toJson<String>(title),
      'versionLabel': serializer.toJson<String>(versionLabel),
      'approved': serializer.toJson<bool>(approved),
      'published': serializer.toJson<bool>(published),
      'sortIndex': serializer.toJson<int>(sortIndex),
    };
  }

  DesignRow copyWith({
    String? id,
    String? projectId,
    String? title,
    String? versionLabel,
    bool? approved,
    bool? published,
    int? sortIndex,
  }) => DesignRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    title: title ?? this.title,
    versionLabel: versionLabel ?? this.versionLabel,
    approved: approved ?? this.approved,
    published: published ?? this.published,
    sortIndex: sortIndex ?? this.sortIndex,
  );
  DesignRow copyWithCompanion(DesignsCompanion data) {
    return DesignRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      title: data.title.present ? data.title.value : this.title,
      versionLabel: data.versionLabel.present
          ? data.versionLabel.value
          : this.versionLabel,
      approved: data.approved.present ? data.approved.value : this.approved,
      published: data.published.present ? data.published.value : this.published,
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DesignRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('versionLabel: $versionLabel, ')
          ..write('approved: $approved, ')
          ..write('published: $published, ')
          ..write('sortIndex: $sortIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    title,
    versionLabel,
    approved,
    published,
    sortIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DesignRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.title == this.title &&
          other.versionLabel == this.versionLabel &&
          other.approved == this.approved &&
          other.published == this.published &&
          other.sortIndex == this.sortIndex);
}

class DesignsCompanion extends UpdateCompanion<DesignRow> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> title;
  final Value<String> versionLabel;
  final Value<bool> approved;
  final Value<bool> published;
  final Value<int> sortIndex;
  final Value<int> rowid;
  const DesignsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.title = const Value.absent(),
    this.versionLabel = const Value.absent(),
    this.approved = const Value.absent(),
    this.published = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DesignsCompanion.insert({
    required String id,
    required String projectId,
    required String title,
    required String versionLabel,
    required bool approved,
    required bool published,
    required int sortIndex,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       title = Value(title),
       versionLabel = Value(versionLabel),
       approved = Value(approved),
       published = Value(published),
       sortIndex = Value(sortIndex);
  static Insertable<DesignRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? title,
    Expression<String>? versionLabel,
    Expression<bool>? approved,
    Expression<bool>? published,
    Expression<int>? sortIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (title != null) 'title': title,
      if (versionLabel != null) 'version_label': versionLabel,
      if (approved != null) 'approved': approved,
      if (published != null) 'published': published,
      if (sortIndex != null) 'sort_index': sortIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DesignsCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? title,
    Value<String>? versionLabel,
    Value<bool>? approved,
    Value<bool>? published,
    Value<int>? sortIndex,
    Value<int>? rowid,
  }) {
    return DesignsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      versionLabel: versionLabel ?? this.versionLabel,
      approved: approved ?? this.approved,
      published: published ?? this.published,
      sortIndex: sortIndex ?? this.sortIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (versionLabel.present) {
      map['version_label'] = Variable<String>(versionLabel.value);
    }
    if (approved.present) {
      map['approved'] = Variable<bool>(approved.value);
    }
    if (published.present) {
      map['published'] = Variable<bool>(published.value);
    }
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DesignsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('versionLabel: $versionLabel, ')
          ..write('approved: $approved, ')
          ..write('published: $published, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DesignAssetsTable extends DesignAssets
    with TableInfo<$DesignAssetsTable, DesignAssetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DesignAssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _designIdMeta = const VerificationMeta(
    'designId',
  );
  @override
  late final GeneratedColumn<String> designId = GeneratedColumn<String>(
    'design_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES designs (id)',
    ),
  );
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES assets (id)',
    ),
  );
  static const VerificationMeta _sortIndexMeta = const VerificationMeta(
    'sortIndex',
  );
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
    'sort_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [designId, assetId, sortIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'design_assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<DesignAssetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('design_id')) {
      context.handle(
        _designIdMeta,
        designId.isAcceptableOrUnknown(data['design_id']!, _designIdMeta),
      );
    } else if (isInserting) {
      context.missing(_designIdMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('sort_index')) {
      context.handle(
        _sortIndexMeta,
        sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_sortIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {designId, assetId};
  @override
  DesignAssetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DesignAssetRow(
      designId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}design_id'],
      )!,
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      )!,
      sortIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_index'],
      )!,
    );
  }

  @override
  $DesignAssetsTable createAlias(String alias) {
    return $DesignAssetsTable(attachedDatabase, alias);
  }
}

class DesignAssetRow extends DataClass implements Insertable<DesignAssetRow> {
  final String designId;
  final String assetId;
  final int sortIndex;
  const DesignAssetRow({
    required this.designId,
    required this.assetId,
    required this.sortIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['design_id'] = Variable<String>(designId);
    map['asset_id'] = Variable<String>(assetId);
    map['sort_index'] = Variable<int>(sortIndex);
    return map;
  }

  DesignAssetsCompanion toCompanion(bool nullToAbsent) {
    return DesignAssetsCompanion(
      designId: Value(designId),
      assetId: Value(assetId),
      sortIndex: Value(sortIndex),
    );
  }

  factory DesignAssetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DesignAssetRow(
      designId: serializer.fromJson<String>(json['designId']),
      assetId: serializer.fromJson<String>(json['assetId']),
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'designId': serializer.toJson<String>(designId),
      'assetId': serializer.toJson<String>(assetId),
      'sortIndex': serializer.toJson<int>(sortIndex),
    };
  }

  DesignAssetRow copyWith({
    String? designId,
    String? assetId,
    int? sortIndex,
  }) => DesignAssetRow(
    designId: designId ?? this.designId,
    assetId: assetId ?? this.assetId,
    sortIndex: sortIndex ?? this.sortIndex,
  );
  DesignAssetRow copyWithCompanion(DesignAssetsCompanion data) {
    return DesignAssetRow(
      designId: data.designId.present ? data.designId.value : this.designId,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DesignAssetRow(')
          ..write('designId: $designId, ')
          ..write('assetId: $assetId, ')
          ..write('sortIndex: $sortIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(designId, assetId, sortIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DesignAssetRow &&
          other.designId == this.designId &&
          other.assetId == this.assetId &&
          other.sortIndex == this.sortIndex);
}

class DesignAssetsCompanion extends UpdateCompanion<DesignAssetRow> {
  final Value<String> designId;
  final Value<String> assetId;
  final Value<int> sortIndex;
  final Value<int> rowid;
  const DesignAssetsCompanion({
    this.designId = const Value.absent(),
    this.assetId = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DesignAssetsCompanion.insert({
    required String designId,
    required String assetId,
    required int sortIndex,
    this.rowid = const Value.absent(),
  }) : designId = Value(designId),
       assetId = Value(assetId),
       sortIndex = Value(sortIndex);
  static Insertable<DesignAssetRow> custom({
    Expression<String>? designId,
    Expression<String>? assetId,
    Expression<int>? sortIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (designId != null) 'design_id': designId,
      if (assetId != null) 'asset_id': assetId,
      if (sortIndex != null) 'sort_index': sortIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DesignAssetsCompanion copyWith({
    Value<String>? designId,
    Value<String>? assetId,
    Value<int>? sortIndex,
    Value<int>? rowid,
  }) {
    return DesignAssetsCompanion(
      designId: designId ?? this.designId,
      assetId: assetId ?? this.assetId,
      sortIndex: sortIndex ?? this.sortIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (designId.present) {
      map['design_id'] = Variable<String>(designId.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DesignAssetsCompanion(')
          ..write('designId: $designId, ')
          ..write('assetId: $assetId, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SupportQueriesTable extends SupportQueries
    with TableInfo<$SupportQueriesTable, SupportQueryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupportQueriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _queueLabelMeta = const VerificationMeta(
    'queueLabel',
  );
  @override
  late final GeneratedColumn<String> queueLabel = GeneratedColumn<String>(
    'queue_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    projectId,
    orderId,
    subject,
    message,
    status,
    queueLabel,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'support_queries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupportQueryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('queue_label')) {
      context.handle(
        _queueLabelMeta,
        queueLabel.isAcceptableOrUnknown(data['queue_label']!, _queueLabelMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupportQueryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupportQueryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      ),
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      ),
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      queueLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}queue_label'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SupportQueriesTable createAlias(String alias) {
    return $SupportQueriesTable(attachedDatabase, alias);
  }
}

class SupportQueryRow extends DataClass implements Insertable<SupportQueryRow> {
  final String id;
  final String accountId;
  final String? projectId;
  final String? orderId;
  final String subject;
  final String message;
  final String status;
  final String? queueLabel;
  final DateTime createdAt;
  const SupportQueryRow({
    required this.id,
    required this.accountId,
    this.projectId,
    this.orderId,
    required this.subject,
    required this.message,
    required this.status,
    this.queueLabel,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    if (!nullToAbsent || orderId != null) {
      map['order_id'] = Variable<String>(orderId);
    }
    map['subject'] = Variable<String>(subject);
    map['message'] = Variable<String>(message);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || queueLabel != null) {
      map['queue_label'] = Variable<String>(queueLabel);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SupportQueriesCompanion toCompanion(bool nullToAbsent) {
    return SupportQueriesCompanion(
      id: Value(id),
      accountId: Value(accountId),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      orderId: orderId == null && nullToAbsent
          ? const Value.absent()
          : Value(orderId),
      subject: Value(subject),
      message: Value(message),
      status: Value(status),
      queueLabel: queueLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(queueLabel),
      createdAt: Value(createdAt),
    );
  }

  factory SupportQueryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupportQueryRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      orderId: serializer.fromJson<String?>(json['orderId']),
      subject: serializer.fromJson<String>(json['subject']),
      message: serializer.fromJson<String>(json['message']),
      status: serializer.fromJson<String>(json['status']),
      queueLabel: serializer.fromJson<String?>(json['queueLabel']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'projectId': serializer.toJson<String?>(projectId),
      'orderId': serializer.toJson<String?>(orderId),
      'subject': serializer.toJson<String>(subject),
      'message': serializer.toJson<String>(message),
      'status': serializer.toJson<String>(status),
      'queueLabel': serializer.toJson<String?>(queueLabel),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SupportQueryRow copyWith({
    String? id,
    String? accountId,
    Value<String?> projectId = const Value.absent(),
    Value<String?> orderId = const Value.absent(),
    String? subject,
    String? message,
    String? status,
    Value<String?> queueLabel = const Value.absent(),
    DateTime? createdAt,
  }) => SupportQueryRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    projectId: projectId.present ? projectId.value : this.projectId,
    orderId: orderId.present ? orderId.value : this.orderId,
    subject: subject ?? this.subject,
    message: message ?? this.message,
    status: status ?? this.status,
    queueLabel: queueLabel.present ? queueLabel.value : this.queueLabel,
    createdAt: createdAt ?? this.createdAt,
  );
  SupportQueryRow copyWithCompanion(SupportQueriesCompanion data) {
    return SupportQueryRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      subject: data.subject.present ? data.subject.value : this.subject,
      message: data.message.present ? data.message.value : this.message,
      status: data.status.present ? data.status.value : this.status,
      queueLabel: data.queueLabel.present
          ? data.queueLabel.value
          : this.queueLabel,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupportQueryRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('projectId: $projectId, ')
          ..write('orderId: $orderId, ')
          ..write('subject: $subject, ')
          ..write('message: $message, ')
          ..write('status: $status, ')
          ..write('queueLabel: $queueLabel, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    projectId,
    orderId,
    subject,
    message,
    status,
    queueLabel,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupportQueryRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.projectId == this.projectId &&
          other.orderId == this.orderId &&
          other.subject == this.subject &&
          other.message == this.message &&
          other.status == this.status &&
          other.queueLabel == this.queueLabel &&
          other.createdAt == this.createdAt);
}

class SupportQueriesCompanion extends UpdateCompanion<SupportQueryRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String?> projectId;
  final Value<String?> orderId;
  final Value<String> subject;
  final Value<String> message;
  final Value<String> status;
  final Value<String?> queueLabel;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SupportQueriesCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.orderId = const Value.absent(),
    this.subject = const Value.absent(),
    this.message = const Value.absent(),
    this.status = const Value.absent(),
    this.queueLabel = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SupportQueriesCompanion.insert({
    required String id,
    required String accountId,
    this.projectId = const Value.absent(),
    this.orderId = const Value.absent(),
    required String subject,
    required String message,
    required String status,
    this.queueLabel = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       subject = Value(subject),
       message = Value(message),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<SupportQueryRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? projectId,
    Expression<String>? orderId,
    Expression<String>? subject,
    Expression<String>? message,
    Expression<String>? status,
    Expression<String>? queueLabel,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (projectId != null) 'project_id': projectId,
      if (orderId != null) 'order_id': orderId,
      if (subject != null) 'subject': subject,
      if (message != null) 'message': message,
      if (status != null) 'status': status,
      if (queueLabel != null) 'queue_label': queueLabel,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SupportQueriesCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String?>? projectId,
    Value<String?>? orderId,
    Value<String>? subject,
    Value<String>? message,
    Value<String>? status,
    Value<String?>? queueLabel,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SupportQueriesCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      projectId: projectId ?? this.projectId,
      orderId: orderId ?? this.orderId,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      status: status ?? this.status,
      queueLabel: queueLabel ?? this.queueLabel,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (queueLabel.present) {
      map['queue_label'] = Variable<String>(queueLabel.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupportQueriesCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('projectId: $projectId, ')
          ..write('orderId: $orderId, ')
          ..write('subject: $subject, ')
          ..write('message: $message, ')
          ..write('status: $status, ')
          ..write('queueLabel: $queueLabel, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DevicesTable extends Devices with TableInfo<$DevicesTable, DeviceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _installationIdMeta = const VerificationMeta(
    'installationId',
  );
  @override
  late final GeneratedColumn<String> installationId = GeneratedColumn<String>(
    'installation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pushTokenMeta = const VerificationMeta(
    'pushToken',
  );
  @override
  late final GeneratedColumn<String> pushToken = GeneratedColumn<String>(
    'push_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    platform,
    installationId,
    pushToken,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('installation_id')) {
      context.handle(
        _installationIdMeta,
        installationId.isAcceptableOrUnknown(
          data['installation_id']!,
          _installationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installationIdMeta);
    }
    if (data.containsKey('push_token')) {
      context.handle(
        _pushTokenMeta,
        pushToken.isAcceptableOrUnknown(data['push_token']!, _pushTokenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeviceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      installationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}installation_id'],
      )!,
      pushToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}push_token'],
      ),
    );
  }

  @override
  $DevicesTable createAlias(String alias) {
    return $DevicesTable(attachedDatabase, alias);
  }
}

class DeviceRow extends DataClass implements Insertable<DeviceRow> {
  final String id;
  final String accountId;
  final String platform;
  final String installationId;
  final String? pushToken;
  const DeviceRow({
    required this.id,
    required this.accountId,
    required this.platform,
    required this.installationId,
    this.pushToken,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['platform'] = Variable<String>(platform);
    map['installation_id'] = Variable<String>(installationId);
    if (!nullToAbsent || pushToken != null) {
      map['push_token'] = Variable<String>(pushToken);
    }
    return map;
  }

  DevicesCompanion toCompanion(bool nullToAbsent) {
    return DevicesCompanion(
      id: Value(id),
      accountId: Value(accountId),
      platform: Value(platform),
      installationId: Value(installationId),
      pushToken: pushToken == null && nullToAbsent
          ? const Value.absent()
          : Value(pushToken),
    );
  }

  factory DeviceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      platform: serializer.fromJson<String>(json['platform']),
      installationId: serializer.fromJson<String>(json['installationId']),
      pushToken: serializer.fromJson<String?>(json['pushToken']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'platform': serializer.toJson<String>(platform),
      'installationId': serializer.toJson<String>(installationId),
      'pushToken': serializer.toJson<String?>(pushToken),
    };
  }

  DeviceRow copyWith({
    String? id,
    String? accountId,
    String? platform,
    String? installationId,
    Value<String?> pushToken = const Value.absent(),
  }) => DeviceRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    platform: platform ?? this.platform,
    installationId: installationId ?? this.installationId,
    pushToken: pushToken.present ? pushToken.value : this.pushToken,
  );
  DeviceRow copyWithCompanion(DevicesCompanion data) {
    return DeviceRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      platform: data.platform.present ? data.platform.value : this.platform,
      installationId: data.installationId.present
          ? data.installationId.value
          : this.installationId,
      pushToken: data.pushToken.present ? data.pushToken.value : this.pushToken,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('platform: $platform, ')
          ..write('installationId: $installationId, ')
          ..write('pushToken: $pushToken')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, accountId, platform, installationId, pushToken);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.platform == this.platform &&
          other.installationId == this.installationId &&
          other.pushToken == this.pushToken);
}

class DevicesCompanion extends UpdateCompanion<DeviceRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> platform;
  final Value<String> installationId;
  final Value<String?> pushToken;
  final Value<int> rowid;
  const DevicesCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.platform = const Value.absent(),
    this.installationId = const Value.absent(),
    this.pushToken = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DevicesCompanion.insert({
    required String id,
    required String accountId,
    required String platform,
    required String installationId,
    this.pushToken = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       platform = Value(platform),
       installationId = Value(installationId);
  static Insertable<DeviceRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? platform,
    Expression<String>? installationId,
    Expression<String>? pushToken,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (platform != null) 'platform': platform,
      if (installationId != null) 'installation_id': installationId,
      if (pushToken != null) 'push_token': pushToken,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DevicesCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? platform,
    Value<String>? installationId,
    Value<String?>? pushToken,
    Value<int>? rowid,
  }) {
    return DevicesCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      platform: platform ?? this.platform,
      installationId: installationId ?? this.installationId,
      pushToken: pushToken ?? this.pushToken,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (installationId.present) {
      map['installation_id'] = Variable<String>(installationId.value);
    }
    if (pushToken.present) {
      map['push_token'] = Variable<String>(pushToken.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DevicesCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('platform: $platform, ')
          ..write('installationId: $installationId, ')
          ..write('pushToken: $pushToken, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InAppNotificationsTable extends InAppNotifications
    with TableInfo<$InAppNotificationsTable, NotificationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InAppNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTypeMeta = const VerificationMeta(
    'targetType',
  );
  @override
  late final GeneratedColumn<String> targetType = GeneratedColumn<String>(
    'target_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<String> targetId = GeneratedColumn<String>(
    'target_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readMeta = const VerificationMeta('read');
  @override
  late final GeneratedColumn<bool> read = GeneratedColumn<bool>(
    'read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    title,
    body,
    targetType,
    targetId,
    read,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'in_app_notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('target_type')) {
      context.handle(
        _targetTypeMeta,
        targetType.isAcceptableOrUnknown(data['target_type']!, _targetTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_targetTypeMeta);
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    if (data.containsKey('read')) {
      context.handle(
        _readMeta,
        read.isAcceptableOrUnknown(data['read']!, _readMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      targetType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_type'],
      )!,
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_id'],
      )!,
      read: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}read'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InAppNotificationsTable createAlias(String alias) {
    return $InAppNotificationsTable(attachedDatabase, alias);
  }
}

class NotificationRow extends DataClass implements Insertable<NotificationRow> {
  final String id;
  final String accountId;
  final String title;
  final String body;
  final String targetType;
  final String targetId;
  final bool read;
  final DateTime createdAt;
  const NotificationRow({
    required this.id,
    required this.accountId,
    required this.title,
    required this.body,
    required this.targetType,
    required this.targetId,
    required this.read,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['target_type'] = Variable<String>(targetType);
    map['target_id'] = Variable<String>(targetId);
    map['read'] = Variable<bool>(read);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InAppNotificationsCompanion toCompanion(bool nullToAbsent) {
    return InAppNotificationsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      title: Value(title),
      body: Value(body),
      targetType: Value(targetType),
      targetId: Value(targetId),
      read: Value(read),
      createdAt: Value(createdAt),
    );
  }

  factory NotificationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      targetType: serializer.fromJson<String>(json['targetType']),
      targetId: serializer.fromJson<String>(json['targetId']),
      read: serializer.fromJson<bool>(json['read']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'targetType': serializer.toJson<String>(targetType),
      'targetId': serializer.toJson<String>(targetId),
      'read': serializer.toJson<bool>(read),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NotificationRow copyWith({
    String? id,
    String? accountId,
    String? title,
    String? body,
    String? targetType,
    String? targetId,
    bool? read,
    DateTime? createdAt,
  }) => NotificationRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    title: title ?? this.title,
    body: body ?? this.body,
    targetType: targetType ?? this.targetType,
    targetId: targetId ?? this.targetId,
    read: read ?? this.read,
    createdAt: createdAt ?? this.createdAt,
  );
  NotificationRow copyWithCompanion(InAppNotificationsCompanion data) {
    return NotificationRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      targetType: data.targetType.present
          ? data.targetType.value
          : this.targetType,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      read: data.read.present ? data.read.value : this.read,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('targetType: $targetType, ')
          ..write('targetId: $targetId, ')
          ..write('read: $read, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    title,
    body,
    targetType,
    targetId,
    read,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.title == this.title &&
          other.body == this.body &&
          other.targetType == this.targetType &&
          other.targetId == this.targetId &&
          other.read == this.read &&
          other.createdAt == this.createdAt);
}

class InAppNotificationsCompanion extends UpdateCompanion<NotificationRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> title;
  final Value<String> body;
  final Value<String> targetType;
  final Value<String> targetId;
  final Value<bool> read;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const InAppNotificationsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.targetType = const Value.absent(),
    this.targetId = const Value.absent(),
    this.read = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InAppNotificationsCompanion.insert({
    required String id,
    required String accountId,
    required String title,
    required String body,
    required String targetType,
    required String targetId,
    this.read = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       title = Value(title),
       body = Value(body),
       targetType = Value(targetType),
       targetId = Value(targetId),
       createdAt = Value(createdAt);
  static Insertable<NotificationRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? targetType,
    Expression<String>? targetId,
    Expression<bool>? read,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (targetType != null) 'target_type': targetType,
      if (targetId != null) 'target_id': targetId,
      if (read != null) 'read': read,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InAppNotificationsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? title,
    Value<String>? body,
    Value<String>? targetType,
    Value<String>? targetId,
    Value<bool>? read,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return InAppNotificationsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      title: title ?? this.title,
      body: body ?? this.body,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (targetType.present) {
      map['target_type'] = Variable<String>(targetType.value);
    }
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (read.present) {
      map['read'] = Variable<bool>(read.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InAppNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('targetType: $targetType, ')
          ..write('targetId: $targetId, ')
          ..write('read: $read, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeliveryAddressesTable extends DeliveryAddresses
    with TableInfo<$DeliveryAddressesTable, DeliveryAddressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeliveryAddressesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  @override
  late final GeneratedColumn<String> mobile = GeneratedColumn<String>(
    'mobile',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineMeta = const VerificationMeta('line');
  @override
  late final GeneratedColumn<String> line = GeneratedColumn<String>(
    'line',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _postcodeMeta = const VerificationMeta(
    'postcode',
  );
  @override
  late final GeneratedColumn<String> postcode = GeneratedColumn<String>(
    'postcode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    accountId,
    fullName,
    mobile,
    line,
    postcode,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'delivery_addresses';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeliveryAddressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('mobile')) {
      context.handle(
        _mobileMeta,
        mobile.isAcceptableOrUnknown(data['mobile']!, _mobileMeta),
      );
    } else if (isInserting) {
      context.missing(_mobileMeta);
    }
    if (data.containsKey('line')) {
      context.handle(
        _lineMeta,
        line.isAcceptableOrUnknown(data['line']!, _lineMeta),
      );
    } else if (isInserting) {
      context.missing(_lineMeta);
    }
    if (data.containsKey('postcode')) {
      context.handle(
        _postcodeMeta,
        postcode.isAcceptableOrUnknown(data['postcode']!, _postcodeMeta),
      );
    } else if (isInserting) {
      context.missing(_postcodeMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accountId};
  @override
  DeliveryAddressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeliveryAddressRow(
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      mobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mobile'],
      )!,
      line: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}line'],
      )!,
      postcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}postcode'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DeliveryAddressesTable createAlias(String alias) {
    return $DeliveryAddressesTable(attachedDatabase, alias);
  }
}

class DeliveryAddressRow extends DataClass
    implements Insertable<DeliveryAddressRow> {
  final String accountId;
  final String fullName;
  final String mobile;
  final String line;
  final String postcode;
  final DateTime updatedAt;
  const DeliveryAddressRow({
    required this.accountId,
    required this.fullName,
    required this.mobile,
    required this.line,
    required this.postcode,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_id'] = Variable<String>(accountId);
    map['full_name'] = Variable<String>(fullName);
    map['mobile'] = Variable<String>(mobile);
    map['line'] = Variable<String>(line);
    map['postcode'] = Variable<String>(postcode);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DeliveryAddressesCompanion toCompanion(bool nullToAbsent) {
    return DeliveryAddressesCompanion(
      accountId: Value(accountId),
      fullName: Value(fullName),
      mobile: Value(mobile),
      line: Value(line),
      postcode: Value(postcode),
      updatedAt: Value(updatedAt),
    );
  }

  factory DeliveryAddressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeliveryAddressRow(
      accountId: serializer.fromJson<String>(json['accountId']),
      fullName: serializer.fromJson<String>(json['fullName']),
      mobile: serializer.fromJson<String>(json['mobile']),
      line: serializer.fromJson<String>(json['line']),
      postcode: serializer.fromJson<String>(json['postcode']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountId': serializer.toJson<String>(accountId),
      'fullName': serializer.toJson<String>(fullName),
      'mobile': serializer.toJson<String>(mobile),
      'line': serializer.toJson<String>(line),
      'postcode': serializer.toJson<String>(postcode),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DeliveryAddressRow copyWith({
    String? accountId,
    String? fullName,
    String? mobile,
    String? line,
    String? postcode,
    DateTime? updatedAt,
  }) => DeliveryAddressRow(
    accountId: accountId ?? this.accountId,
    fullName: fullName ?? this.fullName,
    mobile: mobile ?? this.mobile,
    line: line ?? this.line,
    postcode: postcode ?? this.postcode,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DeliveryAddressRow copyWithCompanion(DeliveryAddressesCompanion data) {
    return DeliveryAddressRow(
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      mobile: data.mobile.present ? data.mobile.value : this.mobile,
      line: data.line.present ? data.line.value : this.line,
      postcode: data.postcode.present ? data.postcode.value : this.postcode,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeliveryAddressRow(')
          ..write('accountId: $accountId, ')
          ..write('fullName: $fullName, ')
          ..write('mobile: $mobile, ')
          ..write('line: $line, ')
          ..write('postcode: $postcode, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(accountId, fullName, mobile, line, postcode, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeliveryAddressRow &&
          other.accountId == this.accountId &&
          other.fullName == this.fullName &&
          other.mobile == this.mobile &&
          other.line == this.line &&
          other.postcode == this.postcode &&
          other.updatedAt == this.updatedAt);
}

class DeliveryAddressesCompanion extends UpdateCompanion<DeliveryAddressRow> {
  final Value<String> accountId;
  final Value<String> fullName;
  final Value<String> mobile;
  final Value<String> line;
  final Value<String> postcode;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DeliveryAddressesCompanion({
    this.accountId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.mobile = const Value.absent(),
    this.line = const Value.absent(),
    this.postcode = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeliveryAddressesCompanion.insert({
    required String accountId,
    required String fullName,
    required String mobile,
    required String line,
    required String postcode,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : accountId = Value(accountId),
       fullName = Value(fullName),
       mobile = Value(mobile),
       line = Value(line),
       postcode = Value(postcode),
       updatedAt = Value(updatedAt);
  static Insertable<DeliveryAddressRow> custom({
    Expression<String>? accountId,
    Expression<String>? fullName,
    Expression<String>? mobile,
    Expression<String>? line,
    Expression<String>? postcode,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountId != null) 'account_id': accountId,
      if (fullName != null) 'full_name': fullName,
      if (mobile != null) 'mobile': mobile,
      if (line != null) 'line': line,
      if (postcode != null) 'postcode': postcode,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeliveryAddressesCompanion copyWith({
    Value<String>? accountId,
    Value<String>? fullName,
    Value<String>? mobile,
    Value<String>? line,
    Value<String>? postcode,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DeliveryAddressesCompanion(
      accountId: accountId ?? this.accountId,
      fullName: fullName ?? this.fullName,
      mobile: mobile ?? this.mobile,
      line: line ?? this.line,
      postcode: postcode ?? this.postcode,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (line.present) {
      map['line'] = Variable<String>(line.value);
    }
    if (postcode.present) {
      map['postcode'] = Variable<String>(postcode.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeliveryAddressesCompanion(')
          ..write('accountId: $accountId, ')
          ..write('fullName: $fullName, ')
          ..write('mobile: $mobile, ')
          ..write('line: $line, ')
          ..write('postcode: $postcode, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShopOrdersTable extends ShopOrders
    with TableInfo<$ShopOrdersTable, ShopOrderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShopOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  @override
  late final GeneratedColumn<String> mobile = GeneratedColumn<String>(
    'mobile',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressLineMeta = const VerificationMeta(
    'addressLine',
  );
  @override
  late final GeneratedColumn<String> addressLine = GeneratedColumn<String>(
    'address_line',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _postcodeMeta = const VerificationMeta(
    'postcode',
  );
  @override
  late final GeneratedColumn<String> postcode = GeneratedColumn<String>(
    'postcode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMinorMeta = const VerificationMeta(
    'totalMinor',
  );
  @override
  late final GeneratedColumn<int> totalMinor = GeneratedColumn<int>(
    'total_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    status,
    fullName,
    mobile,
    addressLine,
    postcode,
    totalMinor,
    currency,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shop_orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShopOrderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('mobile')) {
      context.handle(
        _mobileMeta,
        mobile.isAcceptableOrUnknown(data['mobile']!, _mobileMeta),
      );
    } else if (isInserting) {
      context.missing(_mobileMeta);
    }
    if (data.containsKey('address_line')) {
      context.handle(
        _addressLineMeta,
        addressLine.isAcceptableOrUnknown(
          data['address_line']!,
          _addressLineMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_addressLineMeta);
    }
    if (data.containsKey('postcode')) {
      context.handle(
        _postcodeMeta,
        postcode.isAcceptableOrUnknown(data['postcode']!, _postcodeMeta),
      );
    } else if (isInserting) {
      context.missing(_postcodeMeta);
    }
    if (data.containsKey('total_minor')) {
      context.handle(
        _totalMinorMeta,
        totalMinor.isAcceptableOrUnknown(data['total_minor']!, _totalMinorMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShopOrderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShopOrderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      mobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mobile'],
      )!,
      addressLine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_line'],
      )!,
      postcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}postcode'],
      )!,
      totalMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ShopOrdersTable createAlias(String alias) {
    return $ShopOrdersTable(attachedDatabase, alias);
  }
}

class ShopOrderRow extends DataClass implements Insertable<ShopOrderRow> {
  final String id;
  final String accountId;
  final String status;
  final String fullName;
  final String mobile;
  final String addressLine;
  final String postcode;
  final int totalMinor;
  final String currency;
  final DateTime createdAt;
  const ShopOrderRow({
    required this.id,
    required this.accountId,
    required this.status,
    required this.fullName,
    required this.mobile,
    required this.addressLine,
    required this.postcode,
    required this.totalMinor,
    required this.currency,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['status'] = Variable<String>(status);
    map['full_name'] = Variable<String>(fullName);
    map['mobile'] = Variable<String>(mobile);
    map['address_line'] = Variable<String>(addressLine);
    map['postcode'] = Variable<String>(postcode);
    map['total_minor'] = Variable<int>(totalMinor);
    map['currency'] = Variable<String>(currency);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ShopOrdersCompanion toCompanion(bool nullToAbsent) {
    return ShopOrdersCompanion(
      id: Value(id),
      accountId: Value(accountId),
      status: Value(status),
      fullName: Value(fullName),
      mobile: Value(mobile),
      addressLine: Value(addressLine),
      postcode: Value(postcode),
      totalMinor: Value(totalMinor),
      currency: Value(currency),
      createdAt: Value(createdAt),
    );
  }

  factory ShopOrderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShopOrderRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      status: serializer.fromJson<String>(json['status']),
      fullName: serializer.fromJson<String>(json['fullName']),
      mobile: serializer.fromJson<String>(json['mobile']),
      addressLine: serializer.fromJson<String>(json['addressLine']),
      postcode: serializer.fromJson<String>(json['postcode']),
      totalMinor: serializer.fromJson<int>(json['totalMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'status': serializer.toJson<String>(status),
      'fullName': serializer.toJson<String>(fullName),
      'mobile': serializer.toJson<String>(mobile),
      'addressLine': serializer.toJson<String>(addressLine),
      'postcode': serializer.toJson<String>(postcode),
      'totalMinor': serializer.toJson<int>(totalMinor),
      'currency': serializer.toJson<String>(currency),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ShopOrderRow copyWith({
    String? id,
    String? accountId,
    String? status,
    String? fullName,
    String? mobile,
    String? addressLine,
    String? postcode,
    int? totalMinor,
    String? currency,
    DateTime? createdAt,
  }) => ShopOrderRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    status: status ?? this.status,
    fullName: fullName ?? this.fullName,
    mobile: mobile ?? this.mobile,
    addressLine: addressLine ?? this.addressLine,
    postcode: postcode ?? this.postcode,
    totalMinor: totalMinor ?? this.totalMinor,
    currency: currency ?? this.currency,
    createdAt: createdAt ?? this.createdAt,
  );
  ShopOrderRow copyWithCompanion(ShopOrdersCompanion data) {
    return ShopOrderRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      status: data.status.present ? data.status.value : this.status,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      mobile: data.mobile.present ? data.mobile.value : this.mobile,
      addressLine: data.addressLine.present
          ? data.addressLine.value
          : this.addressLine,
      postcode: data.postcode.present ? data.postcode.value : this.postcode,
      totalMinor: data.totalMinor.present
          ? data.totalMinor.value
          : this.totalMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShopOrderRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('status: $status, ')
          ..write('fullName: $fullName, ')
          ..write('mobile: $mobile, ')
          ..write('addressLine: $addressLine, ')
          ..write('postcode: $postcode, ')
          ..write('totalMinor: $totalMinor, ')
          ..write('currency: $currency, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    status,
    fullName,
    mobile,
    addressLine,
    postcode,
    totalMinor,
    currency,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShopOrderRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.status == this.status &&
          other.fullName == this.fullName &&
          other.mobile == this.mobile &&
          other.addressLine == this.addressLine &&
          other.postcode == this.postcode &&
          other.totalMinor == this.totalMinor &&
          other.currency == this.currency &&
          other.createdAt == this.createdAt);
}

class ShopOrdersCompanion extends UpdateCompanion<ShopOrderRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> status;
  final Value<String> fullName;
  final Value<String> mobile;
  final Value<String> addressLine;
  final Value<String> postcode;
  final Value<int> totalMinor;
  final Value<String> currency;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ShopOrdersCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.status = const Value.absent(),
    this.fullName = const Value.absent(),
    this.mobile = const Value.absent(),
    this.addressLine = const Value.absent(),
    this.postcode = const Value.absent(),
    this.totalMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShopOrdersCompanion.insert({
    required String id,
    required String accountId,
    required String status,
    required String fullName,
    required String mobile,
    required String addressLine,
    required String postcode,
    required int totalMinor,
    required String currency,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       status = Value(status),
       fullName = Value(fullName),
       mobile = Value(mobile),
       addressLine = Value(addressLine),
       postcode = Value(postcode),
       totalMinor = Value(totalMinor),
       currency = Value(currency),
       createdAt = Value(createdAt);
  static Insertable<ShopOrderRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? status,
    Expression<String>? fullName,
    Expression<String>? mobile,
    Expression<String>? addressLine,
    Expression<String>? postcode,
    Expression<int>? totalMinor,
    Expression<String>? currency,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (status != null) 'status': status,
      if (fullName != null) 'full_name': fullName,
      if (mobile != null) 'mobile': mobile,
      if (addressLine != null) 'address_line': addressLine,
      if (postcode != null) 'postcode': postcode,
      if (totalMinor != null) 'total_minor': totalMinor,
      if (currency != null) 'currency': currency,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShopOrdersCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? status,
    Value<String>? fullName,
    Value<String>? mobile,
    Value<String>? addressLine,
    Value<String>? postcode,
    Value<int>? totalMinor,
    Value<String>? currency,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ShopOrdersCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      status: status ?? this.status,
      fullName: fullName ?? this.fullName,
      mobile: mobile ?? this.mobile,
      addressLine: addressLine ?? this.addressLine,
      postcode: postcode ?? this.postcode,
      totalMinor: totalMinor ?? this.totalMinor,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (addressLine.present) {
      map['address_line'] = Variable<String>(addressLine.value);
    }
    if (postcode.present) {
      map['postcode'] = Variable<String>(postcode.value);
    }
    if (totalMinor.present) {
      map['total_minor'] = Variable<int>(totalMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShopOrdersCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('status: $status, ')
          ..write('fullName: $fullName, ')
          ..write('mobile: $mobile, ')
          ..write('addressLine: $addressLine, ')
          ..write('postcode: $postcode, ')
          ..write('totalMinor: $totalMinor, ')
          ..write('currency: $currency, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShopOrderItemsTable extends ShopOrderItems
    with TableInfo<$ShopOrderItemsTable, ShopOrderItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShopOrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shop_orders (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameSnapshotMeta = const VerificationMeta(
    'nameSnapshot',
  );
  @override
  late final GeneratedColumn<String> nameSnapshot = GeneratedColumn<String>(
    'name_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageHintMeta = const VerificationMeta(
    'imageHint',
  );
  @override
  late final GeneratedColumn<String> imageHint = GeneratedColumn<String>(
    'image_hint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMinorMeta = const VerificationMeta(
    'unitPriceMinor',
  );
  @override
  late final GeneratedColumn<int> unitPriceMinor = GeneratedColumn<int>(
    'unit_price_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    productId,
    nameSnapshot,
    imageHint,
    unitPriceMinor,
    currency,
    quantity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shop_order_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShopOrderItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('name_snapshot')) {
      context.handle(
        _nameSnapshotMeta,
        nameSnapshot.isAcceptableOrUnknown(
          data['name_snapshot']!,
          _nameSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameSnapshotMeta);
    }
    if (data.containsKey('image_hint')) {
      context.handle(
        _imageHintMeta,
        imageHint.isAcceptableOrUnknown(data['image_hint']!, _imageHintMeta),
      );
    } else if (isInserting) {
      context.missing(_imageHintMeta);
    }
    if (data.containsKey('unit_price_minor')) {
      context.handle(
        _unitPriceMinorMeta,
        unitPriceMinor.isAcceptableOrUnknown(
          data['unit_price_minor']!,
          _unitPriceMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShopOrderItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShopOrderItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      nameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_snapshot'],
      )!,
      imageHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_hint'],
      )!,
      unitPriceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
    );
  }

  @override
  $ShopOrderItemsTable createAlias(String alias) {
    return $ShopOrderItemsTable(attachedDatabase, alias);
  }
}

class ShopOrderItemRow extends DataClass
    implements Insertable<ShopOrderItemRow> {
  final String id;
  final String orderId;
  final String productId;
  final String nameSnapshot;
  final String imageHint;
  final int unitPriceMinor;
  final String currency;
  final int quantity;
  const ShopOrderItemRow({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.nameSnapshot,
    required this.imageHint,
    required this.unitPriceMinor,
    required this.currency,
    required this.quantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_id'] = Variable<String>(orderId);
    map['product_id'] = Variable<String>(productId);
    map['name_snapshot'] = Variable<String>(nameSnapshot);
    map['image_hint'] = Variable<String>(imageHint);
    map['unit_price_minor'] = Variable<int>(unitPriceMinor);
    map['currency'] = Variable<String>(currency);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  ShopOrderItemsCompanion toCompanion(bool nullToAbsent) {
    return ShopOrderItemsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      productId: Value(productId),
      nameSnapshot: Value(nameSnapshot),
      imageHint: Value(imageHint),
      unitPriceMinor: Value(unitPriceMinor),
      currency: Value(currency),
      quantity: Value(quantity),
    );
  }

  factory ShopOrderItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShopOrderItemRow(
      id: serializer.fromJson<String>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      productId: serializer.fromJson<String>(json['productId']),
      nameSnapshot: serializer.fromJson<String>(json['nameSnapshot']),
      imageHint: serializer.fromJson<String>(json['imageHint']),
      unitPriceMinor: serializer.fromJson<int>(json['unitPriceMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderId': serializer.toJson<String>(orderId),
      'productId': serializer.toJson<String>(productId),
      'nameSnapshot': serializer.toJson<String>(nameSnapshot),
      'imageHint': serializer.toJson<String>(imageHint),
      'unitPriceMinor': serializer.toJson<int>(unitPriceMinor),
      'currency': serializer.toJson<String>(currency),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  ShopOrderItemRow copyWith({
    String? id,
    String? orderId,
    String? productId,
    String? nameSnapshot,
    String? imageHint,
    int? unitPriceMinor,
    String? currency,
    int? quantity,
  }) => ShopOrderItemRow(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    productId: productId ?? this.productId,
    nameSnapshot: nameSnapshot ?? this.nameSnapshot,
    imageHint: imageHint ?? this.imageHint,
    unitPriceMinor: unitPriceMinor ?? this.unitPriceMinor,
    currency: currency ?? this.currency,
    quantity: quantity ?? this.quantity,
  );
  ShopOrderItemRow copyWithCompanion(ShopOrderItemsCompanion data) {
    return ShopOrderItemRow(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      productId: data.productId.present ? data.productId.value : this.productId,
      nameSnapshot: data.nameSnapshot.present
          ? data.nameSnapshot.value
          : this.nameSnapshot,
      imageHint: data.imageHint.present ? data.imageHint.value : this.imageHint,
      unitPriceMinor: data.unitPriceMinor.present
          ? data.unitPriceMinor.value
          : this.unitPriceMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShopOrderItemRow(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('nameSnapshot: $nameSnapshot, ')
          ..write('imageHint: $imageHint, ')
          ..write('unitPriceMinor: $unitPriceMinor, ')
          ..write('currency: $currency, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderId,
    productId,
    nameSnapshot,
    imageHint,
    unitPriceMinor,
    currency,
    quantity,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShopOrderItemRow &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.productId == this.productId &&
          other.nameSnapshot == this.nameSnapshot &&
          other.imageHint == this.imageHint &&
          other.unitPriceMinor == this.unitPriceMinor &&
          other.currency == this.currency &&
          other.quantity == this.quantity);
}

class ShopOrderItemsCompanion extends UpdateCompanion<ShopOrderItemRow> {
  final Value<String> id;
  final Value<String> orderId;
  final Value<String> productId;
  final Value<String> nameSnapshot;
  final Value<String> imageHint;
  final Value<int> unitPriceMinor;
  final Value<String> currency;
  final Value<int> quantity;
  final Value<int> rowid;
  const ShopOrderItemsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.nameSnapshot = const Value.absent(),
    this.imageHint = const Value.absent(),
    this.unitPriceMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.quantity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShopOrderItemsCompanion.insert({
    required String id,
    required String orderId,
    required String productId,
    required String nameSnapshot,
    required String imageHint,
    required int unitPriceMinor,
    required String currency,
    required int quantity,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orderId = Value(orderId),
       productId = Value(productId),
       nameSnapshot = Value(nameSnapshot),
       imageHint = Value(imageHint),
       unitPriceMinor = Value(unitPriceMinor),
       currency = Value(currency),
       quantity = Value(quantity);
  static Insertable<ShopOrderItemRow> custom({
    Expression<String>? id,
    Expression<String>? orderId,
    Expression<String>? productId,
    Expression<String>? nameSnapshot,
    Expression<String>? imageHint,
    Expression<int>? unitPriceMinor,
    Expression<String>? currency,
    Expression<int>? quantity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (productId != null) 'product_id': productId,
      if (nameSnapshot != null) 'name_snapshot': nameSnapshot,
      if (imageHint != null) 'image_hint': imageHint,
      if (unitPriceMinor != null) 'unit_price_minor': unitPriceMinor,
      if (currency != null) 'currency': currency,
      if (quantity != null) 'quantity': quantity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShopOrderItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? orderId,
    Value<String>? productId,
    Value<String>? nameSnapshot,
    Value<String>? imageHint,
    Value<int>? unitPriceMinor,
    Value<String>? currency,
    Value<int>? quantity,
    Value<int>? rowid,
  }) {
    return ShopOrderItemsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      nameSnapshot: nameSnapshot ?? this.nameSnapshot,
      imageHint: imageHint ?? this.imageHint,
      unitPriceMinor: unitPriceMinor ?? this.unitPriceMinor,
      currency: currency ?? this.currency,
      quantity: quantity ?? this.quantity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (nameSnapshot.present) {
      map['name_snapshot'] = Variable<String>(nameSnapshot.value);
    }
    if (imageHint.present) {
      map['image_hint'] = Variable<String>(imageHint.value);
    }
    if (unitPriceMinor.present) {
      map['unit_price_minor'] = Variable<int>(unitPriceMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShopOrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('nameSnapshot: $nameSnapshot, ')
          ..write('imageHint: $imageHint, ')
          ..write('unitPriceMinor: $unitPriceMinor, ')
          ..write('currency: $currency, ')
          ..write('quantity: $quantity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductEnquiriesTable extends ProductEnquiries
    with TableInfo<$ProductEnquiriesTable, ProductEnquiryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductEnquiriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    productId,
    message,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_enquiries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductEnquiryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductEnquiryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductEnquiryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      ),
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      ),
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProductEnquiriesTable createAlias(String alias) {
    return $ProductEnquiriesTable(attachedDatabase, alias);
  }
}

class ProductEnquiryRow extends DataClass
    implements Insertable<ProductEnquiryRow> {
  final String id;
  final String? accountId;
  final String? productId;
  final String message;
  final DateTime createdAt;
  const ProductEnquiryRow({
    required this.id,
    this.accountId,
    this.productId,
    required this.message,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    map['message'] = Variable<String>(message);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProductEnquiriesCompanion toCompanion(bool nullToAbsent) {
    return ProductEnquiriesCompanion(
      id: Value(id),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      message: Value(message),
      createdAt: Value(createdAt),
    );
  }

  factory ProductEnquiryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductEnquiryRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      productId: serializer.fromJson<String?>(json['productId']),
      message: serializer.fromJson<String>(json['message']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String?>(accountId),
      'productId': serializer.toJson<String?>(productId),
      'message': serializer.toJson<String>(message),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProductEnquiryRow copyWith({
    String? id,
    Value<String?> accountId = const Value.absent(),
    Value<String?> productId = const Value.absent(),
    String? message,
    DateTime? createdAt,
  }) => ProductEnquiryRow(
    id: id ?? this.id,
    accountId: accountId.present ? accountId.value : this.accountId,
    productId: productId.present ? productId.value : this.productId,
    message: message ?? this.message,
    createdAt: createdAt ?? this.createdAt,
  );
  ProductEnquiryRow copyWithCompanion(ProductEnquiriesCompanion data) {
    return ProductEnquiryRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      productId: data.productId.present ? data.productId.value : this.productId,
      message: data.message.present ? data.message.value : this.message,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductEnquiryRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('productId: $productId, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, productId, message, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductEnquiryRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.productId == this.productId &&
          other.message == this.message &&
          other.createdAt == this.createdAt);
}

class ProductEnquiriesCompanion extends UpdateCompanion<ProductEnquiryRow> {
  final Value<String> id;
  final Value<String?> accountId;
  final Value<String?> productId;
  final Value<String> message;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProductEnquiriesCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.productId = const Value.absent(),
    this.message = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductEnquiriesCompanion.insert({
    required String id,
    this.accountId = const Value.absent(),
    this.productId = const Value.absent(),
    required String message,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       message = Value(message),
       createdAt = Value(createdAt);
  static Insertable<ProductEnquiryRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? productId,
    Expression<String>? message,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (productId != null) 'product_id': productId,
      if (message != null) 'message': message,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductEnquiriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? accountId,
    Value<String?>? productId,
    Value<String>? message,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ProductEnquiriesCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      productId: productId ?? this.productId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductEnquiriesCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('productId: $productId, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppMetaTable extends AppMeta with TableInfo<$AppMetaTable, AppMetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppMetaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppMetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppMetaRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppMetaTable createAlias(String alias) {
    return $AppMetaTable(attachedDatabase, alias);
  }
}

class AppMetaRow extends DataClass implements Insertable<AppMetaRow> {
  final String key;
  final String value;
  const AppMetaRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppMetaCompanion toCompanion(bool nullToAbsent) {
    return AppMetaCompanion(key: Value(key), value: Value(value));
  }

  factory AppMetaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppMetaRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppMetaRow copyWith({String? key, String? value}) =>
      AppMetaRow(key: key ?? this.key, value: value ?? this.value);
  AppMetaRow copyWithCompanion(AppMetaCompanion data) {
    return AppMetaRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppMetaRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppMetaRow &&
          other.key == this.key &&
          other.value == this.value);
}

class AppMetaCompanion extends UpdateCompanion<AppMetaRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppMetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppMetaRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppMetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $OtpChallengesTable otpChallenges = $OtpChallengesTable(this);
  late final $AuthSessionsTable authSessions = $AuthSessionsTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $MilestonesTable milestones = $MilestonesTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $CartsTable carts = $CartsTable(this);
  late final $CartItemsTable cartItems = $CartItemsTable(this);
  late final $SiteUpdatesTable siteUpdates = $SiteUpdatesTable(this);
  late final $AssetsTable assets = $AssetsTable(this);
  late final $SiteUpdateAssetsTable siteUpdateAssets = $SiteUpdateAssetsTable(
    this,
  );
  late final $ProjectBalancesTable projectBalances = $ProjectBalancesTable(
    this,
  );
  late final $LedgerEntriesTable ledgerEntries = $LedgerEntriesTable(this);
  late final $DueScheduleItemsTable dueScheduleItems = $DueScheduleItemsTable(
    this,
  );
  late final $ProjectDocumentsTable projectDocuments = $ProjectDocumentsTable(
    this,
  );
  late final $DesignsTable designs = $DesignsTable(this);
  late final $DesignAssetsTable designAssets = $DesignAssetsTable(this);
  late final $SupportQueriesTable supportQueries = $SupportQueriesTable(this);
  late final $DevicesTable devices = $DevicesTable(this);
  late final $InAppNotificationsTable inAppNotifications =
      $InAppNotificationsTable(this);
  late final $DeliveryAddressesTable deliveryAddresses =
      $DeliveryAddressesTable(this);
  late final $ShopOrdersTable shopOrders = $ShopOrdersTable(this);
  late final $ShopOrderItemsTable shopOrderItems = $ShopOrderItemsTable(this);
  late final $ProductEnquiriesTable productEnquiries = $ProductEnquiriesTable(
    this,
  );
  late final $AppMetaTable appMeta = $AppMetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    otpChallenges,
    authSessions,
    projects,
    milestones,
    categories,
    products,
    carts,
    cartItems,
    siteUpdates,
    assets,
    siteUpdateAssets,
    projectBalances,
    ledgerEntries,
    dueScheduleItems,
    projectDocuments,
    designs,
    designAssets,
    supportQueries,
    devices,
    inAppNotifications,
    deliveryAddresses,
    shopOrders,
    shopOrderItems,
    productEnquiries,
    appMeta,
  ];
}

typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      required String id,
      required String phone,
      required String displayName,
      required bool hasProjects,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<String> id,
      Value<String> phone,
      Value<String> displayName,
      Value<bool> hasProjects,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, AccountRow> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AuthSessionsTable, List<AuthSessionRow>>
  _authSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.authSessions,
    aliasName: 'accounts__id__auth_sessions__account_id',
  );

  $$AuthSessionsTableProcessedTableManager get authSessionsRefs {
    final manager = $$AuthSessionsTableTableManager(
      $_db,
      $_db.authSessions,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_authSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectsTable, List<ProjectRow>>
  _projectsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.projects,
    aliasName: 'accounts__id__projects__account_id',
  );

  $$ProjectsTableProcessedTableManager get projectsRefs {
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CartsTable, List<CartRow>> _cartsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.carts,
    aliasName: 'accounts__id__carts__account_id',
  );

  $$CartsTableProcessedTableManager get cartsRefs {
    final manager = $$CartsTableTableManager(
      $_db,
      $_db.carts,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cartsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SupportQueriesTable, List<SupportQueryRow>>
  _supportQueriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.supportQueries,
    aliasName: 'accounts__id__support_queries__account_id',
  );

  $$SupportQueriesTableProcessedTableManager get supportQueriesRefs {
    final manager = $$SupportQueriesTableTableManager(
      $_db,
      $_db.supportQueries,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_supportQueriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DevicesTable, List<DeviceRow>> _devicesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.devices,
    aliasName: 'accounts__id__devices__account_id',
  );

  $$DevicesTableProcessedTableManager get devicesRefs {
    final manager = $$DevicesTableTableManager(
      $_db,
      $_db.devices,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_devicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InAppNotificationsTable, List<NotificationRow>>
  _inAppNotificationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.inAppNotifications,
        aliasName: 'accounts__id__in_app_notifications__account_id',
      );

  $$InAppNotificationsTableProcessedTableManager get inAppNotificationsRefs {
    final manager = $$InAppNotificationsTableTableManager(
      $_db,
      $_db.inAppNotifications,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inAppNotificationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DeliveryAddressesTable, List<DeliveryAddressRow>>
  _deliveryAddressesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.deliveryAddresses,
        aliasName: 'accounts__id__delivery_addresses__account_id',
      );

  $$DeliveryAddressesTableProcessedTableManager get deliveryAddressesRefs {
    final manager = $$DeliveryAddressesTableTableManager(
      $_db,
      $_db.deliveryAddresses,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _deliveryAddressesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ShopOrdersTable, List<ShopOrderRow>>
  _shopOrdersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.shopOrders,
    aliasName: 'accounts__id__shop_orders__account_id',
  );

  $$ShopOrdersTableProcessedTableManager get shopOrdersRefs {
    final manager = $$ShopOrdersTableTableManager(
      $_db,
      $_db.shopOrders,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shopOrdersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProductEnquiriesTable, List<ProductEnquiryRow>>
  _productEnquiriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productEnquiries,
    aliasName: 'accounts__id__product_enquiries__account_id',
  );

  $$ProductEnquiriesTableProcessedTableManager get productEnquiriesRefs {
    final manager = $$ProductEnquiriesTableTableManager(
      $_db,
      $_db.productEnquiries,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _productEnquiriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasProjects => $composableBuilder(
    column: $table.hasProjects,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> authSessionsRefs(
    Expression<bool> Function($$AuthSessionsTableFilterComposer f) f,
  ) {
    final $$AuthSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.authSessions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuthSessionsTableFilterComposer(
            $db: $db,
            $table: $db.authSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectsRefs(
    Expression<bool> Function($$ProjectsTableFilterComposer f) f,
  ) {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cartsRefs(
    Expression<bool> Function($$CartsTableFilterComposer f) f,
  ) {
    final $$CartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carts,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartsTableFilterComposer(
            $db: $db,
            $table: $db.carts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> supportQueriesRefs(
    Expression<bool> Function($$SupportQueriesTableFilterComposer f) f,
  ) {
    final $$SupportQueriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.supportQueries,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupportQueriesTableFilterComposer(
            $db: $db,
            $table: $db.supportQueries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> devicesRefs(
    Expression<bool> Function($$DevicesTableFilterComposer f) f,
  ) {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableFilterComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inAppNotificationsRefs(
    Expression<bool> Function($$InAppNotificationsTableFilterComposer f) f,
  ) {
    final $$InAppNotificationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inAppNotifications,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InAppNotificationsTableFilterComposer(
            $db: $db,
            $table: $db.inAppNotifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> deliveryAddressesRefs(
    Expression<bool> Function($$DeliveryAddressesTableFilterComposer f) f,
  ) {
    final $$DeliveryAddressesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deliveryAddresses,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeliveryAddressesTableFilterComposer(
            $db: $db,
            $table: $db.deliveryAddresses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shopOrdersRefs(
    Expression<bool> Function($$ShopOrdersTableFilterComposer f) f,
  ) {
    final $$ShopOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shopOrders,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShopOrdersTableFilterComposer(
            $db: $db,
            $table: $db.shopOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> productEnquiriesRefs(
    Expression<bool> Function($$ProductEnquiriesTableFilterComposer f) f,
  ) {
    final $$ProductEnquiriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productEnquiries,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductEnquiriesTableFilterComposer(
            $db: $db,
            $table: $db.productEnquiries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasProjects => $composableBuilder(
    column: $table.hasProjects,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasProjects => $composableBuilder(
    column: $table.hasProjects,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> authSessionsRefs<T extends Object>(
    Expression<T> Function($$AuthSessionsTableAnnotationComposer a) f,
  ) {
    final $$AuthSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.authSessions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuthSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.authSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> projectsRefs<T extends Object>(
    Expression<T> Function($$ProjectsTableAnnotationComposer a) f,
  ) {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cartsRefs<T extends Object>(
    Expression<T> Function($$CartsTableAnnotationComposer a) f,
  ) {
    final $$CartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carts,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartsTableAnnotationComposer(
            $db: $db,
            $table: $db.carts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> supportQueriesRefs<T extends Object>(
    Expression<T> Function($$SupportQueriesTableAnnotationComposer a) f,
  ) {
    final $$SupportQueriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.supportQueries,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupportQueriesTableAnnotationComposer(
            $db: $db,
            $table: $db.supportQueries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> devicesRefs<T extends Object>(
    Expression<T> Function($$DevicesTableAnnotationComposer a) f,
  ) {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableAnnotationComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> inAppNotificationsRefs<T extends Object>(
    Expression<T> Function($$InAppNotificationsTableAnnotationComposer a) f,
  ) {
    final $$InAppNotificationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.inAppNotifications,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InAppNotificationsTableAnnotationComposer(
                $db: $db,
                $table: $db.inAppNotifications,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> deliveryAddressesRefs<T extends Object>(
    Expression<T> Function($$DeliveryAddressesTableAnnotationComposer a) f,
  ) {
    final $$DeliveryAddressesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.deliveryAddresses,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DeliveryAddressesTableAnnotationComposer(
                $db: $db,
                $table: $db.deliveryAddresses,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> shopOrdersRefs<T extends Object>(
    Expression<T> Function($$ShopOrdersTableAnnotationComposer a) f,
  ) {
    final $$ShopOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shopOrders,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShopOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.shopOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> productEnquiriesRefs<T extends Object>(
    Expression<T> Function($$ProductEnquiriesTableAnnotationComposer a) f,
  ) {
    final $$ProductEnquiriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productEnquiries,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductEnquiriesTableAnnotationComposer(
            $db: $db,
            $table: $db.productEnquiries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          AccountRow,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (AccountRow, $$AccountsTableReferences),
          AccountRow,
          PrefetchHooks Function({
            bool authSessionsRefs,
            bool projectsRefs,
            bool cartsRefs,
            bool supportQueriesRefs,
            bool devicesRefs,
            bool inAppNotificationsRefs,
            bool deliveryAddressesRefs,
            bool shopOrdersRefs,
            bool productEnquiriesRefs,
          })
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<bool> hasProjects = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                phone: phone,
                displayName: displayName,
                hasProjects: hasProjects,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String phone,
                required String displayName,
                required bool hasProjects,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                phone: phone,
                displayName: displayName,
                hasProjects: hasProjects,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                authSessionsRefs = false,
                projectsRefs = false,
                cartsRefs = false,
                supportQueriesRefs = false,
                devicesRefs = false,
                inAppNotificationsRefs = false,
                deliveryAddressesRefs = false,
                shopOrdersRefs = false,
                productEnquiriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (authSessionsRefs) db.authSessions,
                    if (projectsRefs) db.projects,
                    if (cartsRefs) db.carts,
                    if (supportQueriesRefs) db.supportQueries,
                    if (devicesRefs) db.devices,
                    if (inAppNotificationsRefs) db.inAppNotifications,
                    if (deliveryAddressesRefs) db.deliveryAddresses,
                    if (shopOrdersRefs) db.shopOrders,
                    if (productEnquiriesRefs) db.productEnquiries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (authSessionsRefs)
                        await $_getPrefetchedData<
                          AccountRow,
                          $AccountsTable,
                          AuthSessionRow
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._authSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).authSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (projectsRefs)
                        await $_getPrefetchedData<
                          AccountRow,
                          $AccountsTable,
                          ProjectRow
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._projectsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cartsRefs)
                        await $_getPrefetchedData<
                          AccountRow,
                          $AccountsTable,
                          CartRow
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._cartsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).cartsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (supportQueriesRefs)
                        await $_getPrefetchedData<
                          AccountRow,
                          $AccountsTable,
                          SupportQueryRow
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._supportQueriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).supportQueriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (devicesRefs)
                        await $_getPrefetchedData<
                          AccountRow,
                          $AccountsTable,
                          DeviceRow
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._devicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).devicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (inAppNotificationsRefs)
                        await $_getPrefetchedData<
                          AccountRow,
                          $AccountsTable,
                          NotificationRow
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._inAppNotificationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).inAppNotificationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (deliveryAddressesRefs)
                        await $_getPrefetchedData<
                          AccountRow,
                          $AccountsTable,
                          DeliveryAddressRow
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._deliveryAddressesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).deliveryAddressesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shopOrdersRefs)
                        await $_getPrefetchedData<
                          AccountRow,
                          $AccountsTable,
                          ShopOrderRow
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._shopOrdersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).shopOrdersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (productEnquiriesRefs)
                        await $_getPrefetchedData<
                          AccountRow,
                          $AccountsTable,
                          ProductEnquiryRow
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._productEnquiriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).productEnquiriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      AccountRow,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (AccountRow, $$AccountsTableReferences),
      AccountRow,
      PrefetchHooks Function({
        bool authSessionsRefs,
        bool projectsRefs,
        bool cartsRefs,
        bool supportQueriesRefs,
        bool devicesRefs,
        bool inAppNotificationsRefs,
        bool deliveryAddressesRefs,
        bool shopOrdersRefs,
        bool productEnquiriesRefs,
      })
    >;
typedef $$OtpChallengesTableCreateCompanionBuilder =
    OtpChallengesCompanion Function({
      required String id,
      required String phone,
      required String purpose,
      required String code,
      required DateTime expiresAt,
      required DateTime resendAfter,
      Value<bool> consumed,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$OtpChallengesTableUpdateCompanionBuilder =
    OtpChallengesCompanion Function({
      Value<String> id,
      Value<String> phone,
      Value<String> purpose,
      Value<String> code,
      Value<DateTime> expiresAt,
      Value<DateTime> resendAfter,
      Value<bool> consumed,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$OtpChallengesTableFilterComposer
    extends Composer<_$AppDatabase, $OtpChallengesTable> {
  $$OtpChallengesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resendAfter => $composableBuilder(
    column: $table.resendAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get consumed => $composableBuilder(
    column: $table.consumed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OtpChallengesTableOrderingComposer
    extends Composer<_$AppDatabase, $OtpChallengesTable> {
  $$OtpChallengesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resendAfter => $composableBuilder(
    column: $table.resendAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get consumed => $composableBuilder(
    column: $table.consumed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OtpChallengesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OtpChallengesTable> {
  $$OtpChallengesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<DateTime> get resendAfter => $composableBuilder(
    column: $table.resendAfter,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get consumed =>
      $composableBuilder(column: $table.consumed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$OtpChallengesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OtpChallengesTable,
          OtpChallengeRow,
          $$OtpChallengesTableFilterComposer,
          $$OtpChallengesTableOrderingComposer,
          $$OtpChallengesTableAnnotationComposer,
          $$OtpChallengesTableCreateCompanionBuilder,
          $$OtpChallengesTableUpdateCompanionBuilder,
          (
            OtpChallengeRow,
            BaseReferences<_$AppDatabase, $OtpChallengesTable, OtpChallengeRow>,
          ),
          OtpChallengeRow,
          PrefetchHooks Function()
        > {
  $$OtpChallengesTableTableManager(_$AppDatabase db, $OtpChallengesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OtpChallengesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OtpChallengesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OtpChallengesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> purpose = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
                Value<DateTime> resendAfter = const Value.absent(),
                Value<bool> consumed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OtpChallengesCompanion(
                id: id,
                phone: phone,
                purpose: purpose,
                code: code,
                expiresAt: expiresAt,
                resendAfter: resendAfter,
                consumed: consumed,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String phone,
                required String purpose,
                required String code,
                required DateTime expiresAt,
                required DateTime resendAfter,
                Value<bool> consumed = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => OtpChallengesCompanion.insert(
                id: id,
                phone: phone,
                purpose: purpose,
                code: code,
                expiresAt: expiresAt,
                resendAfter: resendAfter,
                consumed: consumed,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OtpChallengesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OtpChallengesTable,
      OtpChallengeRow,
      $$OtpChallengesTableFilterComposer,
      $$OtpChallengesTableOrderingComposer,
      $$OtpChallengesTableAnnotationComposer,
      $$OtpChallengesTableCreateCompanionBuilder,
      $$OtpChallengesTableUpdateCompanionBuilder,
      (
        OtpChallengeRow,
        BaseReferences<_$AppDatabase, $OtpChallengesTable, OtpChallengeRow>,
      ),
      OtpChallengeRow,
      PrefetchHooks Function()
    >;
typedef $$AuthSessionsTableCreateCompanionBuilder =
    AuthSessionsCompanion Function({
      required String id,
      required String accountId,
      required String accessToken,
      required String refreshToken,
      required DateTime expiresAt,
      Value<int> rowid,
    });
typedef $$AuthSessionsTableUpdateCompanionBuilder =
    AuthSessionsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> accessToken,
      Value<String> refreshToken,
      Value<DateTime> expiresAt,
      Value<int> rowid,
    });

final class $$AuthSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $AuthSessionsTable, AuthSessionRow> {
  $$AuthSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('auth_sessions__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AuthSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $AuthSessionsTable> {
  $$AuthSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuthSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuthSessionsTable> {
  $$AuthSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuthSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuthSessionsTable> {
  $$AuthSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuthSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuthSessionsTable,
          AuthSessionRow,
          $$AuthSessionsTableFilterComposer,
          $$AuthSessionsTableOrderingComposer,
          $$AuthSessionsTableAnnotationComposer,
          $$AuthSessionsTableCreateCompanionBuilder,
          $$AuthSessionsTableUpdateCompanionBuilder,
          (AuthSessionRow, $$AuthSessionsTableReferences),
          AuthSessionRow,
          PrefetchHooks Function({bool accountId})
        > {
  $$AuthSessionsTableTableManager(_$AppDatabase db, $AuthSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> accessToken = const Value.absent(),
                Value<String> refreshToken = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuthSessionsCompanion(
                id: id,
                accountId: accountId,
                accessToken: accessToken,
                refreshToken: refreshToken,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String accessToken,
                required String refreshToken,
                required DateTime expiresAt,
                Value<int> rowid = const Value.absent(),
              }) => AuthSessionsCompanion.insert(
                id: id,
                accountId: accountId,
                accessToken: accessToken,
                refreshToken: refreshToken,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AuthSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$AuthSessionsTableReferences
                                    ._accountIdTable(db),
                                referencedColumn: $$AuthSessionsTableReferences
                                    ._accountIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AuthSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuthSessionsTable,
      AuthSessionRow,
      $$AuthSessionsTableFilterComposer,
      $$AuthSessionsTableOrderingComposer,
      $$AuthSessionsTableAnnotationComposer,
      $$AuthSessionsTableCreateCompanionBuilder,
      $$AuthSessionsTableUpdateCompanionBuilder,
      (AuthSessionRow, $$AuthSessionsTableReferences),
      AuthSessionRow,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      required String id,
      required String accountId,
      required String name,
      required String siteLabel,
      required String phaseCode,
      required String phaseLabel,
      Value<int?> progressPercent,
      Value<DateTime?> targetHandoverAt,
      Value<DateTime?> forecastHandoverAt,
      required DateTime updatedAt,
      required String sortCursor,
      Value<int> rowid,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> name,
      Value<String> siteLabel,
      Value<String> phaseCode,
      Value<String> phaseLabel,
      Value<int?> progressPercent,
      Value<DateTime?> targetHandoverAt,
      Value<DateTime?> forecastHandoverAt,
      Value<DateTime> updatedAt,
      Value<String> sortCursor,
      Value<int> rowid,
    });

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, ProjectRow> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('projects__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MilestonesTable, List<MilestoneRow>>
  _milestonesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.milestones,
    aliasName: 'projects__id__milestones__project_id',
  );

  $$MilestonesTableProcessedTableManager get milestonesRefs {
    final manager = $$MilestonesTableTableManager(
      $_db,
      $_db.milestones,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_milestonesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SiteUpdatesTable, List<SiteUpdateRow>>
  _siteUpdatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.siteUpdates,
    aliasName: 'projects__id__site_updates__project_id',
  );

  $$SiteUpdatesTableProcessedTableManager get siteUpdatesRefs {
    final manager = $$SiteUpdatesTableTableManager(
      $_db,
      $_db.siteUpdates,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_siteUpdatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectBalancesTable, List<ProjectBalanceRow>>
  _projectBalancesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.projectBalances,
    aliasName: 'projects__id__project_balances__project_id',
  );

  $$ProjectBalancesTableProcessedTableManager get projectBalancesRefs {
    final manager = $$ProjectBalancesTableTableManager(
      $_db,
      $_db.projectBalances,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _projectBalancesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LedgerEntriesTable, List<LedgerEntryRow>>
  _ledgerEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ledgerEntries,
    aliasName: 'projects__id__ledger_entries__project_id',
  );

  $$LedgerEntriesTableProcessedTableManager get ledgerEntriesRefs {
    final manager = $$LedgerEntriesTableTableManager(
      $_db,
      $_db.ledgerEntries,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ledgerEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DueScheduleItemsTable, List<DueScheduleRow>>
  _dueScheduleItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dueScheduleItems,
    aliasName: 'projects__id__due_schedule_items__project_id',
  );

  $$DueScheduleItemsTableProcessedTableManager get dueScheduleItemsRefs {
    final manager = $$DueScheduleItemsTableTableManager(
      $_db,
      $_db.dueScheduleItems,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dueScheduleItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectDocumentsTable, List<ProjectDocumentRow>>
  _projectDocumentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.projectDocuments,
    aliasName: 'projects__id__project_documents__project_id',
  );

  $$ProjectDocumentsTableProcessedTableManager get projectDocumentsRefs {
    final manager = $$ProjectDocumentsTableTableManager(
      $_db,
      $_db.projectDocuments,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _projectDocumentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DesignsTable, List<DesignRow>> _designsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.designs,
    aliasName: 'projects__id__designs__project_id',
  );

  $$DesignsTableProcessedTableManager get designsRefs {
    final manager = $$DesignsTableTableManager(
      $_db,
      $_db.designs,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_designsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siteLabel => $composableBuilder(
    column: $table.siteLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phaseCode => $composableBuilder(
    column: $table.phaseCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phaseLabel => $composableBuilder(
    column: $table.phaseLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progressPercent => $composableBuilder(
    column: $table.progressPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetHandoverAt => $composableBuilder(
    column: $table.targetHandoverAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get forecastHandoverAt => $composableBuilder(
    column: $table.forecastHandoverAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortCursor => $composableBuilder(
    column: $table.sortCursor,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> milestonesRefs(
    Expression<bool> Function($$MilestonesTableFilterComposer f) f,
  ) {
    final $$MilestonesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.milestones,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MilestonesTableFilterComposer(
            $db: $db,
            $table: $db.milestones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> siteUpdatesRefs(
    Expression<bool> Function($$SiteUpdatesTableFilterComposer f) f,
  ) {
    final $$SiteUpdatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.siteUpdates,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiteUpdatesTableFilterComposer(
            $db: $db,
            $table: $db.siteUpdates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectBalancesRefs(
    Expression<bool> Function($$ProjectBalancesTableFilterComposer f) f,
  ) {
    final $$ProjectBalancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectBalances,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectBalancesTableFilterComposer(
            $db: $db,
            $table: $db.projectBalances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ledgerEntriesRefs(
    Expression<bool> Function($$LedgerEntriesTableFilterComposer f) f,
  ) {
    final $$LedgerEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ledgerEntries,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerEntriesTableFilterComposer(
            $db: $db,
            $table: $db.ledgerEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dueScheduleItemsRefs(
    Expression<bool> Function($$DueScheduleItemsTableFilterComposer f) f,
  ) {
    final $$DueScheduleItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dueScheduleItems,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DueScheduleItemsTableFilterComposer(
            $db: $db,
            $table: $db.dueScheduleItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectDocumentsRefs(
    Expression<bool> Function($$ProjectDocumentsTableFilterComposer f) f,
  ) {
    final $$ProjectDocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectDocuments,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectDocumentsTableFilterComposer(
            $db: $db,
            $table: $db.projectDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> designsRefs(
    Expression<bool> Function($$DesignsTableFilterComposer f) f,
  ) {
    final $$DesignsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.designs,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DesignsTableFilterComposer(
            $db: $db,
            $table: $db.designs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siteLabel => $composableBuilder(
    column: $table.siteLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phaseCode => $composableBuilder(
    column: $table.phaseCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phaseLabel => $composableBuilder(
    column: $table.phaseLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progressPercent => $composableBuilder(
    column: $table.progressPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetHandoverAt => $composableBuilder(
    column: $table.targetHandoverAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get forecastHandoverAt => $composableBuilder(
    column: $table.forecastHandoverAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortCursor => $composableBuilder(
    column: $table.sortCursor,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get siteLabel =>
      $composableBuilder(column: $table.siteLabel, builder: (column) => column);

  GeneratedColumn<String> get phaseCode =>
      $composableBuilder(column: $table.phaseCode, builder: (column) => column);

  GeneratedColumn<String> get phaseLabel => $composableBuilder(
    column: $table.phaseLabel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get progressPercent => $composableBuilder(
    column: $table.progressPercent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get targetHandoverAt => $composableBuilder(
    column: $table.targetHandoverAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get forecastHandoverAt => $composableBuilder(
    column: $table.forecastHandoverAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get sortCursor => $composableBuilder(
    column: $table.sortCursor,
    builder: (column) => column,
  );

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> milestonesRefs<T extends Object>(
    Expression<T> Function($$MilestonesTableAnnotationComposer a) f,
  ) {
    final $$MilestonesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.milestones,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MilestonesTableAnnotationComposer(
            $db: $db,
            $table: $db.milestones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> siteUpdatesRefs<T extends Object>(
    Expression<T> Function($$SiteUpdatesTableAnnotationComposer a) f,
  ) {
    final $$SiteUpdatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.siteUpdates,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiteUpdatesTableAnnotationComposer(
            $db: $db,
            $table: $db.siteUpdates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> projectBalancesRefs<T extends Object>(
    Expression<T> Function($$ProjectBalancesTableAnnotationComposer a) f,
  ) {
    final $$ProjectBalancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectBalances,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectBalancesTableAnnotationComposer(
            $db: $db,
            $table: $db.projectBalances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ledgerEntriesRefs<T extends Object>(
    Expression<T> Function($$LedgerEntriesTableAnnotationComposer a) f,
  ) {
    final $$LedgerEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ledgerEntries,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dueScheduleItemsRefs<T extends Object>(
    Expression<T> Function($$DueScheduleItemsTableAnnotationComposer a) f,
  ) {
    final $$DueScheduleItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dueScheduleItems,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DueScheduleItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.dueScheduleItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> projectDocumentsRefs<T extends Object>(
    Expression<T> Function($$ProjectDocumentsTableAnnotationComposer a) f,
  ) {
    final $$ProjectDocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectDocuments,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectDocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.projectDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> designsRefs<T extends Object>(
    Expression<T> Function($$DesignsTableAnnotationComposer a) f,
  ) {
    final $$DesignsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.designs,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DesignsTableAnnotationComposer(
            $db: $db,
            $table: $db.designs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          ProjectRow,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (ProjectRow, $$ProjectsTableReferences),
          ProjectRow,
          PrefetchHooks Function({
            bool accountId,
            bool milestonesRefs,
            bool siteUpdatesRefs,
            bool projectBalancesRefs,
            bool ledgerEntriesRefs,
            bool dueScheduleItemsRefs,
            bool projectDocumentsRefs,
            bool designsRefs,
          })
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> siteLabel = const Value.absent(),
                Value<String> phaseCode = const Value.absent(),
                Value<String> phaseLabel = const Value.absent(),
                Value<int?> progressPercent = const Value.absent(),
                Value<DateTime?> targetHandoverAt = const Value.absent(),
                Value<DateTime?> forecastHandoverAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> sortCursor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                accountId: accountId,
                name: name,
                siteLabel: siteLabel,
                phaseCode: phaseCode,
                phaseLabel: phaseLabel,
                progressPercent: progressPercent,
                targetHandoverAt: targetHandoverAt,
                forecastHandoverAt: forecastHandoverAt,
                updatedAt: updatedAt,
                sortCursor: sortCursor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String name,
                required String siteLabel,
                required String phaseCode,
                required String phaseLabel,
                Value<int?> progressPercent = const Value.absent(),
                Value<DateTime?> targetHandoverAt = const Value.absent(),
                Value<DateTime?> forecastHandoverAt = const Value.absent(),
                required DateTime updatedAt,
                required String sortCursor,
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                accountId: accountId,
                name: name,
                siteLabel: siteLabel,
                phaseCode: phaseCode,
                phaseLabel: phaseLabel,
                progressPercent: progressPercent,
                targetHandoverAt: targetHandoverAt,
                forecastHandoverAt: forecastHandoverAt,
                updatedAt: updatedAt,
                sortCursor: sortCursor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                accountId = false,
                milestonesRefs = false,
                siteUpdatesRefs = false,
                projectBalancesRefs = false,
                ledgerEntriesRefs = false,
                dueScheduleItemsRefs = false,
                projectDocumentsRefs = false,
                designsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (milestonesRefs) db.milestones,
                    if (siteUpdatesRefs) db.siteUpdates,
                    if (projectBalancesRefs) db.projectBalances,
                    if (ledgerEntriesRefs) db.ledgerEntries,
                    if (dueScheduleItemsRefs) db.dueScheduleItems,
                    if (projectDocumentsRefs) db.projectDocuments,
                    if (designsRefs) db.designs,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accountId,
                                    referencedTable: $$ProjectsTableReferences
                                        ._accountIdTable(db),
                                    referencedColumn: $$ProjectsTableReferences
                                        ._accountIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (milestonesRefs)
                        await $_getPrefetchedData<
                          ProjectRow,
                          $ProjectsTable,
                          MilestoneRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._milestonesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).milestonesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (siteUpdatesRefs)
                        await $_getPrefetchedData<
                          ProjectRow,
                          $ProjectsTable,
                          SiteUpdateRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._siteUpdatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).siteUpdatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (projectBalancesRefs)
                        await $_getPrefetchedData<
                          ProjectRow,
                          $ProjectsTable,
                          ProjectBalanceRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._projectBalancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectBalancesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ledgerEntriesRefs)
                        await $_getPrefetchedData<
                          ProjectRow,
                          $ProjectsTable,
                          LedgerEntryRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._ledgerEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).ledgerEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dueScheduleItemsRefs)
                        await $_getPrefetchedData<
                          ProjectRow,
                          $ProjectsTable,
                          DueScheduleRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._dueScheduleItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).dueScheduleItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (projectDocumentsRefs)
                        await $_getPrefetchedData<
                          ProjectRow,
                          $ProjectsTable,
                          ProjectDocumentRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._projectDocumentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectDocumentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (designsRefs)
                        await $_getPrefetchedData<
                          ProjectRow,
                          $ProjectsTable,
                          DesignRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._designsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).designsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      ProjectRow,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (ProjectRow, $$ProjectsTableReferences),
      ProjectRow,
      PrefetchHooks Function({
        bool accountId,
        bool milestonesRefs,
        bool siteUpdatesRefs,
        bool projectBalancesRefs,
        bool ledgerEntriesRefs,
        bool dueScheduleItemsRefs,
        bool projectDocumentsRefs,
        bool designsRefs,
      })
    >;
typedef $$MilestonesTableCreateCompanionBuilder =
    MilestonesCompanion Function({
      required String id,
      required String projectId,
      required String title,
      required String state,
      required int sortIndex,
      Value<DateTime?> plannedAt,
      Value<DateTime?> completedAt,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$MilestonesTableUpdateCompanionBuilder =
    MilestonesCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> title,
      Value<String> state,
      Value<int> sortIndex,
      Value<DateTime?> plannedAt,
      Value<DateTime?> completedAt,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$MilestonesTableReferences
    extends BaseReferences<_$AppDatabase, $MilestonesTable, MilestoneRow> {
  $$MilestonesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('milestones__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MilestonesTableFilterComposer
    extends Composer<_$AppDatabase, $MilestonesTable> {
  $$MilestonesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get plannedAt => $composableBuilder(
    column: $table.plannedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MilestonesTableOrderingComposer
    extends Composer<_$AppDatabase, $MilestonesTable> {
  $$MilestonesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get plannedAt => $composableBuilder(
    column: $table.plannedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MilestonesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MilestonesTable> {
  $$MilestonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);

  GeneratedColumn<DateTime> get plannedAt =>
      $composableBuilder(column: $table.plannedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MilestonesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MilestonesTable,
          MilestoneRow,
          $$MilestonesTableFilterComposer,
          $$MilestonesTableOrderingComposer,
          $$MilestonesTableAnnotationComposer,
          $$MilestonesTableCreateCompanionBuilder,
          $$MilestonesTableUpdateCompanionBuilder,
          (MilestoneRow, $$MilestonesTableReferences),
          MilestoneRow,
          PrefetchHooks Function({bool projectId})
        > {
  $$MilestonesTableTableManager(_$AppDatabase db, $MilestonesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MilestonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MilestonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MilestonesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int> sortIndex = const Value.absent(),
                Value<DateTime?> plannedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MilestonesCompanion(
                id: id,
                projectId: projectId,
                title: title,
                state: state,
                sortIndex: sortIndex,
                plannedAt: plannedAt,
                completedAt: completedAt,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String title,
                required String state,
                required int sortIndex,
                Value<DateTime?> plannedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MilestonesCompanion.insert(
                id: id,
                projectId: projectId,
                title: title,
                state: state,
                sortIndex: sortIndex,
                plannedAt: plannedAt,
                completedAt: completedAt,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MilestonesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable: $$MilestonesTableReferences
                                    ._projectIdTable(db),
                                referencedColumn: $$MilestonesTableReferences
                                    ._projectIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MilestonesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MilestonesTable,
      MilestoneRow,
      $$MilestonesTableFilterComposer,
      $$MilestonesTableOrderingComposer,
      $$MilestonesTableAnnotationComposer,
      $$MilestonesTableCreateCompanionBuilder,
      $$MilestonesTableUpdateCompanionBuilder,
      (MilestoneRow, $$MilestonesTableReferences),
      MilestoneRow,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String name,
      required int sortIndex,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> sortIndex,
      Value<int> rowid,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductsTable, List<ProductRow>>
  _productsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.products,
    aliasName: 'categories__id__products__category_id',
  );

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productsRefs(
    Expression<bool> Function($$ProductsTableFilterComposer f) f,
  ) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);

  Expression<T> productsRefs<T extends Object>(
    Expression<T> Function($$ProductsTableAnnotationComposer a) f,
  ) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryRow, $$CategoriesTableReferences),
          CategoryRow,
          PrefetchHooks Function({bool productsRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int sortIndex,
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productsRefs) db.products],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productsRefs)
                    await $_getPrefetchedData<
                      CategoryRow,
                      $CategoriesTable,
                      ProductRow
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._productsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).productsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryRow, $$CategoriesTableReferences),
      CategoryRow,
      PrefetchHooks Function({bool productsRefs})
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String categoryId,
      required String name,
      required String description,
      required String salesMode,
      Value<int?> priceMinor,
      Value<String> currency,
      required String specs,
      required String imageHint,
      Value<bool> published,
      required String sortCursor,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> categoryId,
      Value<String> name,
      Value<String> description,
      Value<String> salesMode,
      Value<int?> priceMinor,
      Value<String> currency,
      Value<String> specs,
      Value<String> imageHint,
      Value<bool> published,
      Value<String> sortCursor,
      Value<int> rowid,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, ProductRow> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('products__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CartItemsTable, List<CartItemRow>>
  _cartItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cartItems,
    aliasName: 'products__id__cart_items__product_id',
  );

  $$CartItemsTableProcessedTableManager get cartItemsRefs {
    final manager = $$CartItemsTableTableManager(
      $_db,
      $_db.cartItems,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cartItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get salesMode => $composableBuilder(
    column: $table.salesMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specs => $composableBuilder(
    column: $table.specs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageHint => $composableBuilder(
    column: $table.imageHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get published => $composableBuilder(
    column: $table.published,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortCursor => $composableBuilder(
    column: $table.sortCursor,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cartItemsRefs(
    Expression<bool> Function($$CartItemsTableFilterComposer f) f,
  ) {
    final $$CartItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cartItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartItemsTableFilterComposer(
            $db: $db,
            $table: $db.cartItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get salesMode => $composableBuilder(
    column: $table.salesMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specs => $composableBuilder(
    column: $table.specs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageHint => $composableBuilder(
    column: $table.imageHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get published => $composableBuilder(
    column: $table.published,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortCursor => $composableBuilder(
    column: $table.sortCursor,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get salesMode =>
      $composableBuilder(column: $table.salesMode, builder: (column) => column);

  GeneratedColumn<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get specs =>
      $composableBuilder(column: $table.specs, builder: (column) => column);

  GeneratedColumn<String> get imageHint =>
      $composableBuilder(column: $table.imageHint, builder: (column) => column);

  GeneratedColumn<bool> get published =>
      $composableBuilder(column: $table.published, builder: (column) => column);

  GeneratedColumn<String> get sortCursor => $composableBuilder(
    column: $table.sortCursor,
    builder: (column) => column,
  );

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cartItemsRefs<T extends Object>(
    Expression<T> Function($$CartItemsTableAnnotationComposer a) f,
  ) {
    final $$CartItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cartItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.cartItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          ProductRow,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (ProductRow, $$ProductsTableReferences),
          ProductRow,
          PrefetchHooks Function({bool categoryId, bool cartItemsRefs})
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> salesMode = const Value.absent(),
                Value<int?> priceMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> specs = const Value.absent(),
                Value<String> imageHint = const Value.absent(),
                Value<bool> published = const Value.absent(),
                Value<String> sortCursor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                categoryId: categoryId,
                name: name,
                description: description,
                salesMode: salesMode,
                priceMinor: priceMinor,
                currency: currency,
                specs: specs,
                imageHint: imageHint,
                published: published,
                sortCursor: sortCursor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String categoryId,
                required String name,
                required String description,
                required String salesMode,
                Value<int?> priceMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                required String specs,
                required String imageHint,
                Value<bool> published = const Value.absent(),
                required String sortCursor,
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                categoryId: categoryId,
                name: name,
                description: description,
                salesMode: salesMode,
                priceMinor: priceMinor,
                currency: currency,
                specs: specs,
                imageHint: imageHint,
                published: published,
                sortCursor: sortCursor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false, cartItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (cartItemsRefs) db.cartItems],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$ProductsTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn: $$ProductsTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cartItemsRefs)
                    await $_getPrefetchedData<
                      ProductRow,
                      $ProductsTable,
                      CartItemRow
                    >(
                      currentTable: table,
                      referencedTable: $$ProductsTableReferences
                          ._cartItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ProductsTableReferences(
                        db,
                        table,
                        p0,
                      ).cartItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.productId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      ProductRow,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (ProductRow, $$ProductsTableReferences),
      ProductRow,
      PrefetchHooks Function({bool categoryId, bool cartItemsRefs})
    >;
typedef $$CartsTableCreateCompanionBuilder =
    CartsCompanion Function({
      required String id,
      Value<String?> accountId,
      required int totalMinor,
      Value<String> currency,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$CartsTableUpdateCompanionBuilder =
    CartsCompanion Function({
      Value<String> id,
      Value<String?> accountId,
      Value<int> totalMinor,
      Value<String> currency,
      Value<int> version,
      Value<int> rowid,
    });

final class $$CartsTableReferences
    extends BaseReferences<_$AppDatabase, $CartsTable, CartRow> {
  $$CartsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('carts__account_id__accounts__id');

  $$AccountsTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<String>('account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CartItemsTable, List<CartItemRow>>
  _cartItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cartItems,
    aliasName: 'carts__id__cart_items__cart_id',
  );

  $$CartItemsTableProcessedTableManager get cartItemsRefs {
    final manager = $$CartItemsTableTableManager(
      $_db,
      $_db.cartItems,
    ).filter((f) => f.cartId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cartItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CartsTableFilterComposer extends Composer<_$AppDatabase, $CartsTable> {
  $$CartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cartItemsRefs(
    Expression<bool> Function($$CartItemsTableFilterComposer f) f,
  ) {
    final $$CartItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cartItems,
      getReferencedColumn: (t) => t.cartId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartItemsTableFilterComposer(
            $db: $db,
            $table: $db.cartItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CartsTableOrderingComposer
    extends Composer<_$AppDatabase, $CartsTable> {
  $$CartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CartsTable> {
  $$CartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cartItemsRefs<T extends Object>(
    Expression<T> Function($$CartItemsTableAnnotationComposer a) f,
  ) {
    final $$CartItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cartItems,
      getReferencedColumn: (t) => t.cartId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.cartItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CartsTable,
          CartRow,
          $$CartsTableFilterComposer,
          $$CartsTableOrderingComposer,
          $$CartsTableAnnotationComposer,
          $$CartsTableCreateCompanionBuilder,
          $$CartsTableUpdateCompanionBuilder,
          (CartRow, $$CartsTableReferences),
          CartRow,
          PrefetchHooks Function({bool accountId, bool cartItemsRefs})
        > {
  $$CartsTableTableManager(_$AppDatabase db, $CartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<int> totalMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CartsCompanion(
                id: id,
                accountId: accountId,
                totalMinor: totalMinor,
                currency: currency,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> accountId = const Value.absent(),
                required int totalMinor,
                Value<String> currency = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CartsCompanion.insert(
                id: id,
                accountId: accountId,
                totalMinor: totalMinor,
                currency: currency,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CartsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false, cartItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (cartItemsRefs) db.cartItems],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$CartsTableReferences
                                    ._accountIdTable(db),
                                referencedColumn: $$CartsTableReferences
                                    ._accountIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cartItemsRefs)
                    await $_getPrefetchedData<
                      CartRow,
                      $CartsTable,
                      CartItemRow
                    >(
                      currentTable: table,
                      referencedTable: $$CartsTableReferences
                          ._cartItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CartsTableReferences(db, table, p0).cartItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.cartId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CartsTable,
      CartRow,
      $$CartsTableFilterComposer,
      $$CartsTableOrderingComposer,
      $$CartsTableAnnotationComposer,
      $$CartsTableCreateCompanionBuilder,
      $$CartsTableUpdateCompanionBuilder,
      (CartRow, $$CartsTableReferences),
      CartRow,
      PrefetchHooks Function({bool accountId, bool cartItemsRefs})
    >;
typedef $$CartItemsTableCreateCompanionBuilder =
    CartItemsCompanion Function({
      required String id,
      required String cartId,
      required String productId,
      required String nameSnapshot,
      required int unitPriceMinor,
      required String currency,
      required int quantity,
      Value<bool> unavailable,
      Value<bool> repriced,
      Value<int> rowid,
    });
typedef $$CartItemsTableUpdateCompanionBuilder =
    CartItemsCompanion Function({
      Value<String> id,
      Value<String> cartId,
      Value<String> productId,
      Value<String> nameSnapshot,
      Value<int> unitPriceMinor,
      Value<String> currency,
      Value<int> quantity,
      Value<bool> unavailable,
      Value<bool> repriced,
      Value<int> rowid,
    });

final class $$CartItemsTableReferences
    extends BaseReferences<_$AppDatabase, $CartItemsTable, CartItemRow> {
  $$CartItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CartsTable _cartIdTable(_$AppDatabase db) =>
      db.carts.createAlias('cart_items__cart_id__carts__id');

  $$CartsTableProcessedTableManager get cartId {
    final $_column = $_itemColumn<String>('cart_id')!;

    final manager = $$CartsTableTableManager(
      $_db,
      $_db.carts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cartIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('cart_items__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CartItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get unavailable => $composableBuilder(
    column: $table.unavailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get repriced => $composableBuilder(
    column: $table.repriced,
    builder: (column) => ColumnFilters(column),
  );

  $$CartsTableFilterComposer get cartId {
    final $$CartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cartId,
      referencedTable: $db.carts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartsTableFilterComposer(
            $db: $db,
            $table: $db.carts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CartItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get unavailable => $composableBuilder(
    column: $table.unavailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get repriced => $composableBuilder(
    column: $table.repriced,
    builder: (column) => ColumnOrderings(column),
  );

  $$CartsTableOrderingComposer get cartId {
    final $$CartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cartId,
      referencedTable: $db.carts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartsTableOrderingComposer(
            $db: $db,
            $table: $db.carts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CartItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<bool> get unavailable => $composableBuilder(
    column: $table.unavailable,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get repriced =>
      $composableBuilder(column: $table.repriced, builder: (column) => column);

  $$CartsTableAnnotationComposer get cartId {
    final $$CartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cartId,
      referencedTable: $db.carts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartsTableAnnotationComposer(
            $db: $db,
            $table: $db.carts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CartItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CartItemsTable,
          CartItemRow,
          $$CartItemsTableFilterComposer,
          $$CartItemsTableOrderingComposer,
          $$CartItemsTableAnnotationComposer,
          $$CartItemsTableCreateCompanionBuilder,
          $$CartItemsTableUpdateCompanionBuilder,
          (CartItemRow, $$CartItemsTableReferences),
          CartItemRow,
          PrefetchHooks Function({bool cartId, bool productId})
        > {
  $$CartItemsTableTableManager(_$AppDatabase db, $CartItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CartItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CartItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CartItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cartId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> nameSnapshot = const Value.absent(),
                Value<int> unitPriceMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<bool> unavailable = const Value.absent(),
                Value<bool> repriced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CartItemsCompanion(
                id: id,
                cartId: cartId,
                productId: productId,
                nameSnapshot: nameSnapshot,
                unitPriceMinor: unitPriceMinor,
                currency: currency,
                quantity: quantity,
                unavailable: unavailable,
                repriced: repriced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cartId,
                required String productId,
                required String nameSnapshot,
                required int unitPriceMinor,
                required String currency,
                required int quantity,
                Value<bool> unavailable = const Value.absent(),
                Value<bool> repriced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CartItemsCompanion.insert(
                id: id,
                cartId: cartId,
                productId: productId,
                nameSnapshot: nameSnapshot,
                unitPriceMinor: unitPriceMinor,
                currency: currency,
                quantity: quantity,
                unavailable: unavailable,
                repriced: repriced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CartItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cartId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cartId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cartId,
                                referencedTable: $$CartItemsTableReferences
                                    ._cartIdTable(db),
                                referencedColumn: $$CartItemsTableReferences
                                    ._cartIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$CartItemsTableReferences
                                    ._productIdTable(db),
                                referencedColumn: $$CartItemsTableReferences
                                    ._productIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CartItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CartItemsTable,
      CartItemRow,
      $$CartItemsTableFilterComposer,
      $$CartItemsTableOrderingComposer,
      $$CartItemsTableAnnotationComposer,
      $$CartItemsTableCreateCompanionBuilder,
      $$CartItemsTableUpdateCompanionBuilder,
      (CartItemRow, $$CartItemsTableReferences),
      CartItemRow,
      PrefetchHooks Function({bool cartId, bool productId})
    >;
typedef $$SiteUpdatesTableCreateCompanionBuilder =
    SiteUpdatesCompanion Function({
      required String id,
      required String projectId,
      required bool published,
      Value<String?> note,
      required DateTime eventAt,
      required String sortCursor,
      Value<int> rowid,
    });
typedef $$SiteUpdatesTableUpdateCompanionBuilder =
    SiteUpdatesCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<bool> published,
      Value<String?> note,
      Value<DateTime> eventAt,
      Value<String> sortCursor,
      Value<int> rowid,
    });

final class $$SiteUpdatesTableReferences
    extends BaseReferences<_$AppDatabase, $SiteUpdatesTable, SiteUpdateRow> {
  $$SiteUpdatesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('site_updates__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SiteUpdateAssetsTable, List<SiteUpdateAssetRow>>
  _siteUpdateAssetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.siteUpdateAssets,
    aliasName: 'site_updates__id__site_update_assets__update_id',
  );

  $$SiteUpdateAssetsTableProcessedTableManager get siteUpdateAssetsRefs {
    final manager = $$SiteUpdateAssetsTableTableManager(
      $_db,
      $_db.siteUpdateAssets,
    ).filter((f) => f.updateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _siteUpdateAssetsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SiteUpdatesTableFilterComposer
    extends Composer<_$AppDatabase, $SiteUpdatesTable> {
  $$SiteUpdatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get published => $composableBuilder(
    column: $table.published,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get eventAt => $composableBuilder(
    column: $table.eventAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortCursor => $composableBuilder(
    column: $table.sortCursor,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> siteUpdateAssetsRefs(
    Expression<bool> Function($$SiteUpdateAssetsTableFilterComposer f) f,
  ) {
    final $$SiteUpdateAssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.siteUpdateAssets,
      getReferencedColumn: (t) => t.updateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiteUpdateAssetsTableFilterComposer(
            $db: $db,
            $table: $db.siteUpdateAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SiteUpdatesTableOrderingComposer
    extends Composer<_$AppDatabase, $SiteUpdatesTable> {
  $$SiteUpdatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get published => $composableBuilder(
    column: $table.published,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get eventAt => $composableBuilder(
    column: $table.eventAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortCursor => $composableBuilder(
    column: $table.sortCursor,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SiteUpdatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SiteUpdatesTable> {
  $$SiteUpdatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get published =>
      $composableBuilder(column: $table.published, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get eventAt =>
      $composableBuilder(column: $table.eventAt, builder: (column) => column);

  GeneratedColumn<String> get sortCursor => $composableBuilder(
    column: $table.sortCursor,
    builder: (column) => column,
  );

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> siteUpdateAssetsRefs<T extends Object>(
    Expression<T> Function($$SiteUpdateAssetsTableAnnotationComposer a) f,
  ) {
    final $$SiteUpdateAssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.siteUpdateAssets,
      getReferencedColumn: (t) => t.updateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiteUpdateAssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.siteUpdateAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SiteUpdatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SiteUpdatesTable,
          SiteUpdateRow,
          $$SiteUpdatesTableFilterComposer,
          $$SiteUpdatesTableOrderingComposer,
          $$SiteUpdatesTableAnnotationComposer,
          $$SiteUpdatesTableCreateCompanionBuilder,
          $$SiteUpdatesTableUpdateCompanionBuilder,
          (SiteUpdateRow, $$SiteUpdatesTableReferences),
          SiteUpdateRow,
          PrefetchHooks Function({bool projectId, bool siteUpdateAssetsRefs})
        > {
  $$SiteUpdatesTableTableManager(_$AppDatabase db, $SiteUpdatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SiteUpdatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SiteUpdatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SiteUpdatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<bool> published = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> eventAt = const Value.absent(),
                Value<String> sortCursor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SiteUpdatesCompanion(
                id: id,
                projectId: projectId,
                published: published,
                note: note,
                eventAt: eventAt,
                sortCursor: sortCursor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required bool published,
                Value<String?> note = const Value.absent(),
                required DateTime eventAt,
                required String sortCursor,
                Value<int> rowid = const Value.absent(),
              }) => SiteUpdatesCompanion.insert(
                id: id,
                projectId: projectId,
                published: published,
                note: note,
                eventAt: eventAt,
                sortCursor: sortCursor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SiteUpdatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({projectId = false, siteUpdateAssetsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (siteUpdateAssetsRefs) db.siteUpdateAssets,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable:
                                        $$SiteUpdatesTableReferences
                                            ._projectIdTable(db),
                                    referencedColumn:
                                        $$SiteUpdatesTableReferences
                                            ._projectIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (siteUpdateAssetsRefs)
                        await $_getPrefetchedData<
                          SiteUpdateRow,
                          $SiteUpdatesTable,
                          SiteUpdateAssetRow
                        >(
                          currentTable: table,
                          referencedTable: $$SiteUpdatesTableReferences
                              ._siteUpdateAssetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SiteUpdatesTableReferences(
                                db,
                                table,
                                p0,
                              ).siteUpdateAssetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.updateId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SiteUpdatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SiteUpdatesTable,
      SiteUpdateRow,
      $$SiteUpdatesTableFilterComposer,
      $$SiteUpdatesTableOrderingComposer,
      $$SiteUpdatesTableAnnotationComposer,
      $$SiteUpdatesTableCreateCompanionBuilder,
      $$SiteUpdatesTableUpdateCompanionBuilder,
      (SiteUpdateRow, $$SiteUpdatesTableReferences),
      SiteUpdateRow,
      PrefetchHooks Function({bool projectId, bool siteUpdateAssetsRefs})
    >;
typedef $$AssetsTableCreateCompanionBuilder =
    AssetsCompanion Function({
      required String id,
      required String visualHint,
      Value<String?> caption,
      required bool published,
      Value<bool> withdrawn,
      Value<int> rowid,
    });
typedef $$AssetsTableUpdateCompanionBuilder =
    AssetsCompanion Function({
      Value<String> id,
      Value<String> visualHint,
      Value<String?> caption,
      Value<bool> published,
      Value<bool> withdrawn,
      Value<int> rowid,
    });

final class $$AssetsTableReferences
    extends BaseReferences<_$AppDatabase, $AssetsTable, AssetRow> {
  $$AssetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SiteUpdateAssetsTable, List<SiteUpdateAssetRow>>
  _siteUpdateAssetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.siteUpdateAssets,
    aliasName: 'assets__id__site_update_assets__asset_id',
  );

  $$SiteUpdateAssetsTableProcessedTableManager get siteUpdateAssetsRefs {
    final manager = $$SiteUpdateAssetsTableTableManager(
      $_db,
      $_db.siteUpdateAssets,
    ).filter((f) => f.assetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _siteUpdateAssetsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectDocumentsTable, List<ProjectDocumentRow>>
  _projectDocumentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.projectDocuments,
    aliasName: 'assets__id__project_documents__asset_id',
  );

  $$ProjectDocumentsTableProcessedTableManager get projectDocumentsRefs {
    final manager = $$ProjectDocumentsTableTableManager(
      $_db,
      $_db.projectDocuments,
    ).filter((f) => f.assetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _projectDocumentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DesignAssetsTable, List<DesignAssetRow>>
  _designAssetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.designAssets,
    aliasName: 'assets__id__design_assets__asset_id',
  );

  $$DesignAssetsTableProcessedTableManager get designAssetsRefs {
    final manager = $$DesignAssetsTableTableManager(
      $_db,
      $_db.designAssets,
    ).filter((f) => f.assetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_designAssetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AssetsTableFilterComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visualHint => $composableBuilder(
    column: $table.visualHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get published => $composableBuilder(
    column: $table.published,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get withdrawn => $composableBuilder(
    column: $table.withdrawn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> siteUpdateAssetsRefs(
    Expression<bool> Function($$SiteUpdateAssetsTableFilterComposer f) f,
  ) {
    final $$SiteUpdateAssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.siteUpdateAssets,
      getReferencedColumn: (t) => t.assetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiteUpdateAssetsTableFilterComposer(
            $db: $db,
            $table: $db.siteUpdateAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectDocumentsRefs(
    Expression<bool> Function($$ProjectDocumentsTableFilterComposer f) f,
  ) {
    final $$ProjectDocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectDocuments,
      getReferencedColumn: (t) => t.assetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectDocumentsTableFilterComposer(
            $db: $db,
            $table: $db.projectDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> designAssetsRefs(
    Expression<bool> Function($$DesignAssetsTableFilterComposer f) f,
  ) {
    final $$DesignAssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.designAssets,
      getReferencedColumn: (t) => t.assetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DesignAssetsTableFilterComposer(
            $db: $db,
            $table: $db.designAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visualHint => $composableBuilder(
    column: $table.visualHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get published => $composableBuilder(
    column: $table.published,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get withdrawn => $composableBuilder(
    column: $table.withdrawn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get visualHint => $composableBuilder(
    column: $table.visualHint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<bool> get published =>
      $composableBuilder(column: $table.published, builder: (column) => column);

  GeneratedColumn<bool> get withdrawn =>
      $composableBuilder(column: $table.withdrawn, builder: (column) => column);

  Expression<T> siteUpdateAssetsRefs<T extends Object>(
    Expression<T> Function($$SiteUpdateAssetsTableAnnotationComposer a) f,
  ) {
    final $$SiteUpdateAssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.siteUpdateAssets,
      getReferencedColumn: (t) => t.assetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiteUpdateAssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.siteUpdateAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> projectDocumentsRefs<T extends Object>(
    Expression<T> Function($$ProjectDocumentsTableAnnotationComposer a) f,
  ) {
    final $$ProjectDocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectDocuments,
      getReferencedColumn: (t) => t.assetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectDocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.projectDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> designAssetsRefs<T extends Object>(
    Expression<T> Function($$DesignAssetsTableAnnotationComposer a) f,
  ) {
    final $$DesignAssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.designAssets,
      getReferencedColumn: (t) => t.assetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DesignAssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.designAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AssetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssetsTable,
          AssetRow,
          $$AssetsTableFilterComposer,
          $$AssetsTableOrderingComposer,
          $$AssetsTableAnnotationComposer,
          $$AssetsTableCreateCompanionBuilder,
          $$AssetsTableUpdateCompanionBuilder,
          (AssetRow, $$AssetsTableReferences),
          AssetRow,
          PrefetchHooks Function({
            bool siteUpdateAssetsRefs,
            bool projectDocumentsRefs,
            bool designAssetsRefs,
          })
        > {
  $$AssetsTableTableManager(_$AppDatabase db, $AssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> visualHint = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<bool> published = const Value.absent(),
                Value<bool> withdrawn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion(
                id: id,
                visualHint: visualHint,
                caption: caption,
                published: published,
                withdrawn: withdrawn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String visualHint,
                Value<String?> caption = const Value.absent(),
                required bool published,
                Value<bool> withdrawn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion.insert(
                id: id,
                visualHint: visualHint,
                caption: caption,
                published: published,
                withdrawn: withdrawn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$AssetsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                siteUpdateAssetsRefs = false,
                projectDocumentsRefs = false,
                designAssetsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (siteUpdateAssetsRefs) db.siteUpdateAssets,
                    if (projectDocumentsRefs) db.projectDocuments,
                    if (designAssetsRefs) db.designAssets,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (siteUpdateAssetsRefs)
                        await $_getPrefetchedData<
                          AssetRow,
                          $AssetsTable,
                          SiteUpdateAssetRow
                        >(
                          currentTable: table,
                          referencedTable: $$AssetsTableReferences
                              ._siteUpdateAssetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AssetsTableReferences(
                                db,
                                table,
                                p0,
                              ).siteUpdateAssetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.assetId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (projectDocumentsRefs)
                        await $_getPrefetchedData<
                          AssetRow,
                          $AssetsTable,
                          ProjectDocumentRow
                        >(
                          currentTable: table,
                          referencedTable: $$AssetsTableReferences
                              ._projectDocumentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AssetsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectDocumentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.assetId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (designAssetsRefs)
                        await $_getPrefetchedData<
                          AssetRow,
                          $AssetsTable,
                          DesignAssetRow
                        >(
                          currentTable: table,
                          referencedTable: $$AssetsTableReferences
                              ._designAssetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AssetsTableReferences(
                                db,
                                table,
                                p0,
                              ).designAssetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.assetId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssetsTable,
      AssetRow,
      $$AssetsTableFilterComposer,
      $$AssetsTableOrderingComposer,
      $$AssetsTableAnnotationComposer,
      $$AssetsTableCreateCompanionBuilder,
      $$AssetsTableUpdateCompanionBuilder,
      (AssetRow, $$AssetsTableReferences),
      AssetRow,
      PrefetchHooks Function({
        bool siteUpdateAssetsRefs,
        bool projectDocumentsRefs,
        bool designAssetsRefs,
      })
    >;
typedef $$SiteUpdateAssetsTableCreateCompanionBuilder =
    SiteUpdateAssetsCompanion Function({
      required String updateId,
      required String assetId,
      required int sortIndex,
      Value<int> rowid,
    });
typedef $$SiteUpdateAssetsTableUpdateCompanionBuilder =
    SiteUpdateAssetsCompanion Function({
      Value<String> updateId,
      Value<String> assetId,
      Value<int> sortIndex,
      Value<int> rowid,
    });

final class $$SiteUpdateAssetsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SiteUpdateAssetsTable,
          SiteUpdateAssetRow
        > {
  $$SiteUpdateAssetsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SiteUpdatesTable _updateIdTable(_$AppDatabase db) => db.siteUpdates
      .createAlias('site_update_assets__update_id__site_updates__id');

  $$SiteUpdatesTableProcessedTableManager get updateId {
    final $_column = $_itemColumn<String>('update_id')!;

    final manager = $$SiteUpdatesTableTableManager(
      $_db,
      $_db.siteUpdates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_updateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AssetsTable _assetIdTable(_$AppDatabase db) =>
      db.assets.createAlias('site_update_assets__asset_id__assets__id');

  $$AssetsTableProcessedTableManager get assetId {
    final $_column = $_itemColumn<String>('asset_id')!;

    final manager = $$AssetsTableTableManager(
      $_db,
      $_db.assets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SiteUpdateAssetsTableFilterComposer
    extends Composer<_$AppDatabase, $SiteUpdateAssetsTable> {
  $$SiteUpdateAssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$SiteUpdatesTableFilterComposer get updateId {
    final $$SiteUpdatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.updateId,
      referencedTable: $db.siteUpdates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiteUpdatesTableFilterComposer(
            $db: $db,
            $table: $db.siteUpdates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetsTableFilterComposer get assetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableFilterComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SiteUpdateAssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $SiteUpdateAssetsTable> {
  $$SiteUpdateAssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$SiteUpdatesTableOrderingComposer get updateId {
    final $$SiteUpdatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.updateId,
      referencedTable: $db.siteUpdates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiteUpdatesTableOrderingComposer(
            $db: $db,
            $table: $db.siteUpdates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetsTableOrderingComposer get assetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableOrderingComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SiteUpdateAssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SiteUpdateAssetsTable> {
  $$SiteUpdateAssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);

  $$SiteUpdatesTableAnnotationComposer get updateId {
    final $$SiteUpdatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.updateId,
      referencedTable: $db.siteUpdates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiteUpdatesTableAnnotationComposer(
            $db: $db,
            $table: $db.siteUpdates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetsTableAnnotationComposer get assetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SiteUpdateAssetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SiteUpdateAssetsTable,
          SiteUpdateAssetRow,
          $$SiteUpdateAssetsTableFilterComposer,
          $$SiteUpdateAssetsTableOrderingComposer,
          $$SiteUpdateAssetsTableAnnotationComposer,
          $$SiteUpdateAssetsTableCreateCompanionBuilder,
          $$SiteUpdateAssetsTableUpdateCompanionBuilder,
          (SiteUpdateAssetRow, $$SiteUpdateAssetsTableReferences),
          SiteUpdateAssetRow,
          PrefetchHooks Function({bool updateId, bool assetId})
        > {
  $$SiteUpdateAssetsTableTableManager(
    _$AppDatabase db,
    $SiteUpdateAssetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SiteUpdateAssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SiteUpdateAssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SiteUpdateAssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> updateId = const Value.absent(),
                Value<String> assetId = const Value.absent(),
                Value<int> sortIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SiteUpdateAssetsCompanion(
                updateId: updateId,
                assetId: assetId,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String updateId,
                required String assetId,
                required int sortIndex,
                Value<int> rowid = const Value.absent(),
              }) => SiteUpdateAssetsCompanion.insert(
                updateId: updateId,
                assetId: assetId,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SiteUpdateAssetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({updateId = false, assetId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (updateId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.updateId,
                                referencedTable:
                                    $$SiteUpdateAssetsTableReferences
                                        ._updateIdTable(db),
                                referencedColumn:
                                    $$SiteUpdateAssetsTableReferences
                                        ._updateIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (assetId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.assetId,
                                referencedTable:
                                    $$SiteUpdateAssetsTableReferences
                                        ._assetIdTable(db),
                                referencedColumn:
                                    $$SiteUpdateAssetsTableReferences
                                        ._assetIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SiteUpdateAssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SiteUpdateAssetsTable,
      SiteUpdateAssetRow,
      $$SiteUpdateAssetsTableFilterComposer,
      $$SiteUpdateAssetsTableOrderingComposer,
      $$SiteUpdateAssetsTableAnnotationComposer,
      $$SiteUpdateAssetsTableCreateCompanionBuilder,
      $$SiteUpdateAssetsTableUpdateCompanionBuilder,
      (SiteUpdateAssetRow, $$SiteUpdateAssetsTableReferences),
      SiteUpdateAssetRow,
      PrefetchHooks Function({bool updateId, bool assetId})
    >;
typedef $$ProjectBalancesTableCreateCompanionBuilder =
    ProjectBalancesCompanion Function({
      required String projectId,
      required String currency,
      required DateTime asOf,
      required int totalContractMinor,
      required int approvedVariationsMinor,
      required int netReceivedMinor,
      required int outstandingTotalMinor,
      required int amountCurrentlyDueMinor,
      required int creditOverpaymentMinor,
      Value<int> rowid,
    });
typedef $$ProjectBalancesTableUpdateCompanionBuilder =
    ProjectBalancesCompanion Function({
      Value<String> projectId,
      Value<String> currency,
      Value<DateTime> asOf,
      Value<int> totalContractMinor,
      Value<int> approvedVariationsMinor,
      Value<int> netReceivedMinor,
      Value<int> outstandingTotalMinor,
      Value<int> amountCurrentlyDueMinor,
      Value<int> creditOverpaymentMinor,
      Value<int> rowid,
    });

final class $$ProjectBalancesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProjectBalancesTable,
          ProjectBalanceRow
        > {
  $$ProjectBalancesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('project_balances__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProjectBalancesTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectBalancesTable> {
  $$ProjectBalancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get asOf => $composableBuilder(
    column: $table.asOf,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalContractMinor => $composableBuilder(
    column: $table.totalContractMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get approvedVariationsMinor => $composableBuilder(
    column: $table.approvedVariationsMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get netReceivedMinor => $composableBuilder(
    column: $table.netReceivedMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get outstandingTotalMinor => $composableBuilder(
    column: $table.outstandingTotalMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCurrentlyDueMinor => $composableBuilder(
    column: $table.amountCurrentlyDueMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditOverpaymentMinor => $composableBuilder(
    column: $table.creditOverpaymentMinor,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectBalancesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectBalancesTable> {
  $$ProjectBalancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get asOf => $composableBuilder(
    column: $table.asOf,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalContractMinor => $composableBuilder(
    column: $table.totalContractMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get approvedVariationsMinor => $composableBuilder(
    column: $table.approvedVariationsMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get netReceivedMinor => $composableBuilder(
    column: $table.netReceivedMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get outstandingTotalMinor => $composableBuilder(
    column: $table.outstandingTotalMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCurrentlyDueMinor => $composableBuilder(
    column: $table.amountCurrentlyDueMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditOverpaymentMinor => $composableBuilder(
    column: $table.creditOverpaymentMinor,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectBalancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectBalancesTable> {
  $$ProjectBalancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get asOf =>
      $composableBuilder(column: $table.asOf, builder: (column) => column);

  GeneratedColumn<int> get totalContractMinor => $composableBuilder(
    column: $table.totalContractMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get approvedVariationsMinor => $composableBuilder(
    column: $table.approvedVariationsMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get netReceivedMinor => $composableBuilder(
    column: $table.netReceivedMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get outstandingTotalMinor => $composableBuilder(
    column: $table.outstandingTotalMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountCurrentlyDueMinor => $composableBuilder(
    column: $table.amountCurrentlyDueMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get creditOverpaymentMinor => $composableBuilder(
    column: $table.creditOverpaymentMinor,
    builder: (column) => column,
  );

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectBalancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectBalancesTable,
          ProjectBalanceRow,
          $$ProjectBalancesTableFilterComposer,
          $$ProjectBalancesTableOrderingComposer,
          $$ProjectBalancesTableAnnotationComposer,
          $$ProjectBalancesTableCreateCompanionBuilder,
          $$ProjectBalancesTableUpdateCompanionBuilder,
          (ProjectBalanceRow, $$ProjectBalancesTableReferences),
          ProjectBalanceRow,
          PrefetchHooks Function({bool projectId})
        > {
  $$ProjectBalancesTableTableManager(
    _$AppDatabase db,
    $ProjectBalancesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectBalancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectBalancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectBalancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> projectId = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime> asOf = const Value.absent(),
                Value<int> totalContractMinor = const Value.absent(),
                Value<int> approvedVariationsMinor = const Value.absent(),
                Value<int> netReceivedMinor = const Value.absent(),
                Value<int> outstandingTotalMinor = const Value.absent(),
                Value<int> amountCurrentlyDueMinor = const Value.absent(),
                Value<int> creditOverpaymentMinor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectBalancesCompanion(
                projectId: projectId,
                currency: currency,
                asOf: asOf,
                totalContractMinor: totalContractMinor,
                approvedVariationsMinor: approvedVariationsMinor,
                netReceivedMinor: netReceivedMinor,
                outstandingTotalMinor: outstandingTotalMinor,
                amountCurrentlyDueMinor: amountCurrentlyDueMinor,
                creditOverpaymentMinor: creditOverpaymentMinor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String projectId,
                required String currency,
                required DateTime asOf,
                required int totalContractMinor,
                required int approvedVariationsMinor,
                required int netReceivedMinor,
                required int outstandingTotalMinor,
                required int amountCurrentlyDueMinor,
                required int creditOverpaymentMinor,
                Value<int> rowid = const Value.absent(),
              }) => ProjectBalancesCompanion.insert(
                projectId: projectId,
                currency: currency,
                asOf: asOf,
                totalContractMinor: totalContractMinor,
                approvedVariationsMinor: approvedVariationsMinor,
                netReceivedMinor: netReceivedMinor,
                outstandingTotalMinor: outstandingTotalMinor,
                amountCurrentlyDueMinor: amountCurrentlyDueMinor,
                creditOverpaymentMinor: creditOverpaymentMinor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectBalancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable:
                                    $$ProjectBalancesTableReferences
                                        ._projectIdTable(db),
                                referencedColumn:
                                    $$ProjectBalancesTableReferences
                                        ._projectIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProjectBalancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectBalancesTable,
      ProjectBalanceRow,
      $$ProjectBalancesTableFilterComposer,
      $$ProjectBalancesTableOrderingComposer,
      $$ProjectBalancesTableAnnotationComposer,
      $$ProjectBalancesTableCreateCompanionBuilder,
      $$ProjectBalancesTableUpdateCompanionBuilder,
      (ProjectBalanceRow, $$ProjectBalancesTableReferences),
      ProjectBalanceRow,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$LedgerEntriesTableCreateCompanionBuilder =
    LedgerEntriesCompanion Function({
      required String id,
      required String projectId,
      required String description,
      required String state,
      required int amountMinor,
      required String currency,
      required DateTime postedAt,
      required String sortCursor,
      Value<int> rowid,
    });
typedef $$LedgerEntriesTableUpdateCompanionBuilder =
    LedgerEntriesCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> description,
      Value<String> state,
      Value<int> amountMinor,
      Value<String> currency,
      Value<DateTime> postedAt,
      Value<String> sortCursor,
      Value<int> rowid,
    });

final class $$LedgerEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $LedgerEntriesTable, LedgerEntryRow> {
  $$LedgerEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('ledger_entries__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LedgerEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get postedAt => $composableBuilder(
    column: $table.postedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortCursor => $composableBuilder(
    column: $table.sortCursor,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LedgerEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get postedAt => $composableBuilder(
    column: $table.postedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortCursor => $composableBuilder(
    column: $table.sortCursor,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LedgerEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get postedAt =>
      $composableBuilder(column: $table.postedAt, builder: (column) => column);

  GeneratedColumn<String> get sortCursor => $composableBuilder(
    column: $table.sortCursor,
    builder: (column) => column,
  );

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LedgerEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LedgerEntriesTable,
          LedgerEntryRow,
          $$LedgerEntriesTableFilterComposer,
          $$LedgerEntriesTableOrderingComposer,
          $$LedgerEntriesTableAnnotationComposer,
          $$LedgerEntriesTableCreateCompanionBuilder,
          $$LedgerEntriesTableUpdateCompanionBuilder,
          (LedgerEntryRow, $$LedgerEntriesTableReferences),
          LedgerEntryRow,
          PrefetchHooks Function({bool projectId})
        > {
  $$LedgerEntriesTableTableManager(_$AppDatabase db, $LedgerEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LedgerEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LedgerEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LedgerEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime> postedAt = const Value.absent(),
                Value<String> sortCursor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LedgerEntriesCompanion(
                id: id,
                projectId: projectId,
                description: description,
                state: state,
                amountMinor: amountMinor,
                currency: currency,
                postedAt: postedAt,
                sortCursor: sortCursor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String description,
                required String state,
                required int amountMinor,
                required String currency,
                required DateTime postedAt,
                required String sortCursor,
                Value<int> rowid = const Value.absent(),
              }) => LedgerEntriesCompanion.insert(
                id: id,
                projectId: projectId,
                description: description,
                state: state,
                amountMinor: amountMinor,
                currency: currency,
                postedAt: postedAt,
                sortCursor: sortCursor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LedgerEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable: $$LedgerEntriesTableReferences
                                    ._projectIdTable(db),
                                referencedColumn: $$LedgerEntriesTableReferences
                                    ._projectIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LedgerEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LedgerEntriesTable,
      LedgerEntryRow,
      $$LedgerEntriesTableFilterComposer,
      $$LedgerEntriesTableOrderingComposer,
      $$LedgerEntriesTableAnnotationComposer,
      $$LedgerEntriesTableCreateCompanionBuilder,
      $$LedgerEntriesTableUpdateCompanionBuilder,
      (LedgerEntryRow, $$LedgerEntriesTableReferences),
      LedgerEntryRow,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$DueScheduleItemsTableCreateCompanionBuilder =
    DueScheduleItemsCompanion Function({
      required String id,
      required String projectId,
      required String label,
      required int amountMinor,
      required String currency,
      required DateTime dueAt,
      required int sortIndex,
      Value<int> rowid,
    });
typedef $$DueScheduleItemsTableUpdateCompanionBuilder =
    DueScheduleItemsCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> label,
      Value<int> amountMinor,
      Value<String> currency,
      Value<DateTime> dueAt,
      Value<int> sortIndex,
      Value<int> rowid,
    });

final class $$DueScheduleItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $DueScheduleItemsTable, DueScheduleRow> {
  $$DueScheduleItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('due_schedule_items__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DueScheduleItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DueScheduleItemsTable> {
  $$DueScheduleItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DueScheduleItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DueScheduleItemsTable> {
  $$DueScheduleItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DueScheduleItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DueScheduleItemsTable> {
  $$DueScheduleItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DueScheduleItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DueScheduleItemsTable,
          DueScheduleRow,
          $$DueScheduleItemsTableFilterComposer,
          $$DueScheduleItemsTableOrderingComposer,
          $$DueScheduleItemsTableAnnotationComposer,
          $$DueScheduleItemsTableCreateCompanionBuilder,
          $$DueScheduleItemsTableUpdateCompanionBuilder,
          (DueScheduleRow, $$DueScheduleItemsTableReferences),
          DueScheduleRow,
          PrefetchHooks Function({bool projectId})
        > {
  $$DueScheduleItemsTableTableManager(
    _$AppDatabase db,
    $DueScheduleItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DueScheduleItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DueScheduleItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DueScheduleItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime> dueAt = const Value.absent(),
                Value<int> sortIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DueScheduleItemsCompanion(
                id: id,
                projectId: projectId,
                label: label,
                amountMinor: amountMinor,
                currency: currency,
                dueAt: dueAt,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String label,
                required int amountMinor,
                required String currency,
                required DateTime dueAt,
                required int sortIndex,
                Value<int> rowid = const Value.absent(),
              }) => DueScheduleItemsCompanion.insert(
                id: id,
                projectId: projectId,
                label: label,
                amountMinor: amountMinor,
                currency: currency,
                dueAt: dueAt,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DueScheduleItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable:
                                    $$DueScheduleItemsTableReferences
                                        ._projectIdTable(db),
                                referencedColumn:
                                    $$DueScheduleItemsTableReferences
                                        ._projectIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DueScheduleItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DueScheduleItemsTable,
      DueScheduleRow,
      $$DueScheduleItemsTableFilterComposer,
      $$DueScheduleItemsTableOrderingComposer,
      $$DueScheduleItemsTableAnnotationComposer,
      $$DueScheduleItemsTableCreateCompanionBuilder,
      $$DueScheduleItemsTableUpdateCompanionBuilder,
      (DueScheduleRow, $$DueScheduleItemsTableReferences),
      DueScheduleRow,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$ProjectDocumentsTableCreateCompanionBuilder =
    ProjectDocumentsCompanion Function({
      required String id,
      required String projectId,
      required String type,
      required String title,
      required String assetId,
      required bool published,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ProjectDocumentsTableUpdateCompanionBuilder =
    ProjectDocumentsCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> type,
      Value<String> title,
      Value<String> assetId,
      Value<bool> published,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ProjectDocumentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProjectDocumentsTable,
          ProjectDocumentRow
        > {
  $$ProjectDocumentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('project_documents__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AssetsTable _assetIdTable(_$AppDatabase db) =>
      db.assets.createAlias('project_documents__asset_id__assets__id');

  $$AssetsTableProcessedTableManager get assetId {
    final $_column = $_itemColumn<String>('asset_id')!;

    final manager = $$AssetsTableTableManager(
      $_db,
      $_db.assets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProjectDocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectDocumentsTable> {
  $$ProjectDocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get published => $composableBuilder(
    column: $table.published,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetsTableFilterComposer get assetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableFilterComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectDocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectDocumentsTable> {
  $$ProjectDocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get published => $composableBuilder(
    column: $table.published,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetsTableOrderingComposer get assetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableOrderingComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectDocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectDocumentsTable> {
  $$ProjectDocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get published =>
      $composableBuilder(column: $table.published, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetsTableAnnotationComposer get assetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectDocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectDocumentsTable,
          ProjectDocumentRow,
          $$ProjectDocumentsTableFilterComposer,
          $$ProjectDocumentsTableOrderingComposer,
          $$ProjectDocumentsTableAnnotationComposer,
          $$ProjectDocumentsTableCreateCompanionBuilder,
          $$ProjectDocumentsTableUpdateCompanionBuilder,
          (ProjectDocumentRow, $$ProjectDocumentsTableReferences),
          ProjectDocumentRow,
          PrefetchHooks Function({bool projectId, bool assetId})
        > {
  $$ProjectDocumentsTableTableManager(
    _$AppDatabase db,
    $ProjectDocumentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectDocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectDocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectDocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> assetId = const Value.absent(),
                Value<bool> published = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectDocumentsCompanion(
                id: id,
                projectId: projectId,
                type: type,
                title: title,
                assetId: assetId,
                published: published,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String type,
                required String title,
                required String assetId,
                required bool published,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ProjectDocumentsCompanion.insert(
                id: id,
                projectId: projectId,
                type: type,
                title: title,
                assetId: assetId,
                published: published,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectDocumentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false, assetId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable:
                                    $$ProjectDocumentsTableReferences
                                        ._projectIdTable(db),
                                referencedColumn:
                                    $$ProjectDocumentsTableReferences
                                        ._projectIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (assetId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.assetId,
                                referencedTable:
                                    $$ProjectDocumentsTableReferences
                                        ._assetIdTable(db),
                                referencedColumn:
                                    $$ProjectDocumentsTableReferences
                                        ._assetIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProjectDocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectDocumentsTable,
      ProjectDocumentRow,
      $$ProjectDocumentsTableFilterComposer,
      $$ProjectDocumentsTableOrderingComposer,
      $$ProjectDocumentsTableAnnotationComposer,
      $$ProjectDocumentsTableCreateCompanionBuilder,
      $$ProjectDocumentsTableUpdateCompanionBuilder,
      (ProjectDocumentRow, $$ProjectDocumentsTableReferences),
      ProjectDocumentRow,
      PrefetchHooks Function({bool projectId, bool assetId})
    >;
typedef $$DesignsTableCreateCompanionBuilder =
    DesignsCompanion Function({
      required String id,
      required String projectId,
      required String title,
      required String versionLabel,
      required bool approved,
      required bool published,
      required int sortIndex,
      Value<int> rowid,
    });
typedef $$DesignsTableUpdateCompanionBuilder =
    DesignsCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> title,
      Value<String> versionLabel,
      Value<bool> approved,
      Value<bool> published,
      Value<int> sortIndex,
      Value<int> rowid,
    });

final class $$DesignsTableReferences
    extends BaseReferences<_$AppDatabase, $DesignsTable, DesignRow> {
  $$DesignsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('designs__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$DesignAssetsTable, List<DesignAssetRow>>
  _designAssetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.designAssets,
    aliasName: 'designs__id__design_assets__design_id',
  );

  $$DesignAssetsTableProcessedTableManager get designAssetsRefs {
    final manager = $$DesignAssetsTableTableManager(
      $_db,
      $_db.designAssets,
    ).filter((f) => f.designId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_designAssetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DesignsTableFilterComposer
    extends Composer<_$AppDatabase, $DesignsTable> {
  $$DesignsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get versionLabel => $composableBuilder(
    column: $table.versionLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get approved => $composableBuilder(
    column: $table.approved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get published => $composableBuilder(
    column: $table.published,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> designAssetsRefs(
    Expression<bool> Function($$DesignAssetsTableFilterComposer f) f,
  ) {
    final $$DesignAssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.designAssets,
      getReferencedColumn: (t) => t.designId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DesignAssetsTableFilterComposer(
            $db: $db,
            $table: $db.designAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DesignsTableOrderingComposer
    extends Composer<_$AppDatabase, $DesignsTable> {
  $$DesignsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get versionLabel => $composableBuilder(
    column: $table.versionLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get approved => $composableBuilder(
    column: $table.approved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get published => $composableBuilder(
    column: $table.published,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DesignsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DesignsTable> {
  $$DesignsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get versionLabel => $composableBuilder(
    column: $table.versionLabel,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get approved =>
      $composableBuilder(column: $table.approved, builder: (column) => column);

  GeneratedColumn<bool> get published =>
      $composableBuilder(column: $table.published, builder: (column) => column);

  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> designAssetsRefs<T extends Object>(
    Expression<T> Function($$DesignAssetsTableAnnotationComposer a) f,
  ) {
    final $$DesignAssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.designAssets,
      getReferencedColumn: (t) => t.designId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DesignAssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.designAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DesignsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DesignsTable,
          DesignRow,
          $$DesignsTableFilterComposer,
          $$DesignsTableOrderingComposer,
          $$DesignsTableAnnotationComposer,
          $$DesignsTableCreateCompanionBuilder,
          $$DesignsTableUpdateCompanionBuilder,
          (DesignRow, $$DesignsTableReferences),
          DesignRow,
          PrefetchHooks Function({bool projectId, bool designAssetsRefs})
        > {
  $$DesignsTableTableManager(_$AppDatabase db, $DesignsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DesignsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DesignsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DesignsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> versionLabel = const Value.absent(),
                Value<bool> approved = const Value.absent(),
                Value<bool> published = const Value.absent(),
                Value<int> sortIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DesignsCompanion(
                id: id,
                projectId: projectId,
                title: title,
                versionLabel: versionLabel,
                approved: approved,
                published: published,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String title,
                required String versionLabel,
                required bool approved,
                required bool published,
                required int sortIndex,
                Value<int> rowid = const Value.absent(),
              }) => DesignsCompanion.insert(
                id: id,
                projectId: projectId,
                title: title,
                versionLabel: versionLabel,
                approved: approved,
                published: published,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DesignsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({projectId = false, designAssetsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (designAssetsRefs) db.designAssets,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable: $$DesignsTableReferences
                                        ._projectIdTable(db),
                                    referencedColumn: $$DesignsTableReferences
                                        ._projectIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (designAssetsRefs)
                        await $_getPrefetchedData<
                          DesignRow,
                          $DesignsTable,
                          DesignAssetRow
                        >(
                          currentTable: table,
                          referencedTable: $$DesignsTableReferences
                              ._designAssetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DesignsTableReferences(
                                db,
                                table,
                                p0,
                              ).designAssetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.designId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DesignsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DesignsTable,
      DesignRow,
      $$DesignsTableFilterComposer,
      $$DesignsTableOrderingComposer,
      $$DesignsTableAnnotationComposer,
      $$DesignsTableCreateCompanionBuilder,
      $$DesignsTableUpdateCompanionBuilder,
      (DesignRow, $$DesignsTableReferences),
      DesignRow,
      PrefetchHooks Function({bool projectId, bool designAssetsRefs})
    >;
typedef $$DesignAssetsTableCreateCompanionBuilder =
    DesignAssetsCompanion Function({
      required String designId,
      required String assetId,
      required int sortIndex,
      Value<int> rowid,
    });
typedef $$DesignAssetsTableUpdateCompanionBuilder =
    DesignAssetsCompanion Function({
      Value<String> designId,
      Value<String> assetId,
      Value<int> sortIndex,
      Value<int> rowid,
    });

final class $$DesignAssetsTableReferences
    extends BaseReferences<_$AppDatabase, $DesignAssetsTable, DesignAssetRow> {
  $$DesignAssetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DesignsTable _designIdTable(_$AppDatabase db) =>
      db.designs.createAlias('design_assets__design_id__designs__id');

  $$DesignsTableProcessedTableManager get designId {
    final $_column = $_itemColumn<String>('design_id')!;

    final manager = $$DesignsTableTableManager(
      $_db,
      $_db.designs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_designIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AssetsTable _assetIdTable(_$AppDatabase db) =>
      db.assets.createAlias('design_assets__asset_id__assets__id');

  $$AssetsTableProcessedTableManager get assetId {
    final $_column = $_itemColumn<String>('asset_id')!;

    final manager = $$AssetsTableTableManager(
      $_db,
      $_db.assets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DesignAssetsTableFilterComposer
    extends Composer<_$AppDatabase, $DesignAssetsTable> {
  $$DesignAssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$DesignsTableFilterComposer get designId {
    final $$DesignsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.designId,
      referencedTable: $db.designs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DesignsTableFilterComposer(
            $db: $db,
            $table: $db.designs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetsTableFilterComposer get assetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableFilterComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DesignAssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $DesignAssetsTable> {
  $$DesignAssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$DesignsTableOrderingComposer get designId {
    final $$DesignsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.designId,
      referencedTable: $db.designs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DesignsTableOrderingComposer(
            $db: $db,
            $table: $db.designs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetsTableOrderingComposer get assetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableOrderingComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DesignAssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DesignAssetsTable> {
  $$DesignAssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);

  $$DesignsTableAnnotationComposer get designId {
    final $$DesignsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.designId,
      referencedTable: $db.designs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DesignsTableAnnotationComposer(
            $db: $db,
            $table: $db.designs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetsTableAnnotationComposer get assetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DesignAssetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DesignAssetsTable,
          DesignAssetRow,
          $$DesignAssetsTableFilterComposer,
          $$DesignAssetsTableOrderingComposer,
          $$DesignAssetsTableAnnotationComposer,
          $$DesignAssetsTableCreateCompanionBuilder,
          $$DesignAssetsTableUpdateCompanionBuilder,
          (DesignAssetRow, $$DesignAssetsTableReferences),
          DesignAssetRow,
          PrefetchHooks Function({bool designId, bool assetId})
        > {
  $$DesignAssetsTableTableManager(_$AppDatabase db, $DesignAssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DesignAssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DesignAssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DesignAssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> designId = const Value.absent(),
                Value<String> assetId = const Value.absent(),
                Value<int> sortIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DesignAssetsCompanion(
                designId: designId,
                assetId: assetId,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String designId,
                required String assetId,
                required int sortIndex,
                Value<int> rowid = const Value.absent(),
              }) => DesignAssetsCompanion.insert(
                designId: designId,
                assetId: assetId,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DesignAssetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({designId = false, assetId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (designId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.designId,
                                referencedTable: $$DesignAssetsTableReferences
                                    ._designIdTable(db),
                                referencedColumn: $$DesignAssetsTableReferences
                                    ._designIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (assetId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.assetId,
                                referencedTable: $$DesignAssetsTableReferences
                                    ._assetIdTable(db),
                                referencedColumn: $$DesignAssetsTableReferences
                                    ._assetIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DesignAssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DesignAssetsTable,
      DesignAssetRow,
      $$DesignAssetsTableFilterComposer,
      $$DesignAssetsTableOrderingComposer,
      $$DesignAssetsTableAnnotationComposer,
      $$DesignAssetsTableCreateCompanionBuilder,
      $$DesignAssetsTableUpdateCompanionBuilder,
      (DesignAssetRow, $$DesignAssetsTableReferences),
      DesignAssetRow,
      PrefetchHooks Function({bool designId, bool assetId})
    >;
typedef $$SupportQueriesTableCreateCompanionBuilder =
    SupportQueriesCompanion Function({
      required String id,
      required String accountId,
      Value<String?> projectId,
      Value<String?> orderId,
      required String subject,
      required String message,
      required String status,
      Value<String?> queueLabel,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SupportQueriesTableUpdateCompanionBuilder =
    SupportQueriesCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String?> projectId,
      Value<String?> orderId,
      Value<String> subject,
      Value<String> message,
      Value<String> status,
      Value<String?> queueLabel,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$SupportQueriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $SupportQueriesTable, SupportQueryRow> {
  $$SupportQueriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('support_queries__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SupportQueriesTableFilterComposer
    extends Composer<_$AppDatabase, $SupportQueriesTable> {
  $$SupportQueriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get queueLabel => $composableBuilder(
    column: $table.queueLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SupportQueriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SupportQueriesTable> {
  $$SupportQueriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get queueLabel => $composableBuilder(
    column: $table.queueLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SupportQueriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupportQueriesTable> {
  $$SupportQueriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get queueLabel => $composableBuilder(
    column: $table.queueLabel,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SupportQueriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupportQueriesTable,
          SupportQueryRow,
          $$SupportQueriesTableFilterComposer,
          $$SupportQueriesTableOrderingComposer,
          $$SupportQueriesTableAnnotationComposer,
          $$SupportQueriesTableCreateCompanionBuilder,
          $$SupportQueriesTableUpdateCompanionBuilder,
          (SupportQueryRow, $$SupportQueriesTableReferences),
          SupportQueryRow,
          PrefetchHooks Function({bool accountId})
        > {
  $$SupportQueriesTableTableManager(
    _$AppDatabase db,
    $SupportQueriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupportQueriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupportQueriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupportQueriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<String?> orderId = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> queueLabel = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupportQueriesCompanion(
                id: id,
                accountId: accountId,
                projectId: projectId,
                orderId: orderId,
                subject: subject,
                message: message,
                status: status,
                queueLabel: queueLabel,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                Value<String?> projectId = const Value.absent(),
                Value<String?> orderId = const Value.absent(),
                required String subject,
                required String message,
                required String status,
                Value<String?> queueLabel = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SupportQueriesCompanion.insert(
                id: id,
                accountId: accountId,
                projectId: projectId,
                orderId: orderId,
                subject: subject,
                message: message,
                status: status,
                queueLabel: queueLabel,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SupportQueriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$SupportQueriesTableReferences
                                    ._accountIdTable(db),
                                referencedColumn:
                                    $$SupportQueriesTableReferences
                                        ._accountIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SupportQueriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupportQueriesTable,
      SupportQueryRow,
      $$SupportQueriesTableFilterComposer,
      $$SupportQueriesTableOrderingComposer,
      $$SupportQueriesTableAnnotationComposer,
      $$SupportQueriesTableCreateCompanionBuilder,
      $$SupportQueriesTableUpdateCompanionBuilder,
      (SupportQueryRow, $$SupportQueriesTableReferences),
      SupportQueryRow,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$DevicesTableCreateCompanionBuilder =
    DevicesCompanion Function({
      required String id,
      required String accountId,
      required String platform,
      required String installationId,
      Value<String?> pushToken,
      Value<int> rowid,
    });
typedef $$DevicesTableUpdateCompanionBuilder =
    DevicesCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> platform,
      Value<String> installationId,
      Value<String?> pushToken,
      Value<int> rowid,
    });

final class $$DevicesTableReferences
    extends BaseReferences<_$AppDatabase, $DevicesTable, DeviceRow> {
  $$DevicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('devices__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DevicesTableFilterComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get installationId => $composableBuilder(
    column: $table.installationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pushToken => $composableBuilder(
    column: $table.pushToken,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get installationId => $composableBuilder(
    column: $table.installationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pushToken => $composableBuilder(
    column: $table.pushToken,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get installationId => $composableBuilder(
    column: $table.installationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pushToken =>
      $composableBuilder(column: $table.pushToken, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DevicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DevicesTable,
          DeviceRow,
          $$DevicesTableFilterComposer,
          $$DevicesTableOrderingComposer,
          $$DevicesTableAnnotationComposer,
          $$DevicesTableCreateCompanionBuilder,
          $$DevicesTableUpdateCompanionBuilder,
          (DeviceRow, $$DevicesTableReferences),
          DeviceRow,
          PrefetchHooks Function({bool accountId})
        > {
  $$DevicesTableTableManager(_$AppDatabase db, $DevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<String> installationId = const Value.absent(),
                Value<String?> pushToken = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DevicesCompanion(
                id: id,
                accountId: accountId,
                platform: platform,
                installationId: installationId,
                pushToken: pushToken,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String platform,
                required String installationId,
                Value<String?> pushToken = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DevicesCompanion.insert(
                id: id,
                accountId: accountId,
                platform: platform,
                installationId: installationId,
                pushToken: pushToken,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DevicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$DevicesTableReferences
                                    ._accountIdTable(db),
                                referencedColumn: $$DevicesTableReferences
                                    ._accountIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DevicesTable,
      DeviceRow,
      $$DevicesTableFilterComposer,
      $$DevicesTableOrderingComposer,
      $$DevicesTableAnnotationComposer,
      $$DevicesTableCreateCompanionBuilder,
      $$DevicesTableUpdateCompanionBuilder,
      (DeviceRow, $$DevicesTableReferences),
      DeviceRow,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$InAppNotificationsTableCreateCompanionBuilder =
    InAppNotificationsCompanion Function({
      required String id,
      required String accountId,
      required String title,
      required String body,
      required String targetType,
      required String targetId,
      Value<bool> read,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$InAppNotificationsTableUpdateCompanionBuilder =
    InAppNotificationsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> title,
      Value<String> body,
      Value<String> targetType,
      Value<String> targetId,
      Value<bool> read,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$InAppNotificationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $InAppNotificationsTable,
          NotificationRow
        > {
  $$InAppNotificationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('in_app_notifications__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InAppNotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $InAppNotificationsTable> {
  $$InAppNotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get read => $composableBuilder(
    column: $table.read,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InAppNotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $InAppNotificationsTable> {
  $$InAppNotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get read => $composableBuilder(
    column: $table.read,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InAppNotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InAppNotificationsTable> {
  $$InAppNotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  GeneratedColumn<bool> get read =>
      $composableBuilder(column: $table.read, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InAppNotificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InAppNotificationsTable,
          NotificationRow,
          $$InAppNotificationsTableFilterComposer,
          $$InAppNotificationsTableOrderingComposer,
          $$InAppNotificationsTableAnnotationComposer,
          $$InAppNotificationsTableCreateCompanionBuilder,
          $$InAppNotificationsTableUpdateCompanionBuilder,
          (NotificationRow, $$InAppNotificationsTableReferences),
          NotificationRow,
          PrefetchHooks Function({bool accountId})
        > {
  $$InAppNotificationsTableTableManager(
    _$AppDatabase db,
    $InAppNotificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InAppNotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InAppNotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InAppNotificationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> targetType = const Value.absent(),
                Value<String> targetId = const Value.absent(),
                Value<bool> read = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InAppNotificationsCompanion(
                id: id,
                accountId: accountId,
                title: title,
                body: body,
                targetType: targetType,
                targetId: targetId,
                read: read,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String title,
                required String body,
                required String targetType,
                required String targetId,
                Value<bool> read = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => InAppNotificationsCompanion.insert(
                id: id,
                accountId: accountId,
                title: title,
                body: body,
                targetType: targetType,
                targetId: targetId,
                read: read,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InAppNotificationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable:
                                    $$InAppNotificationsTableReferences
                                        ._accountIdTable(db),
                                referencedColumn:
                                    $$InAppNotificationsTableReferences
                                        ._accountIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InAppNotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InAppNotificationsTable,
      NotificationRow,
      $$InAppNotificationsTableFilterComposer,
      $$InAppNotificationsTableOrderingComposer,
      $$InAppNotificationsTableAnnotationComposer,
      $$InAppNotificationsTableCreateCompanionBuilder,
      $$InAppNotificationsTableUpdateCompanionBuilder,
      (NotificationRow, $$InAppNotificationsTableReferences),
      NotificationRow,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$DeliveryAddressesTableCreateCompanionBuilder =
    DeliveryAddressesCompanion Function({
      required String accountId,
      required String fullName,
      required String mobile,
      required String line,
      required String postcode,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DeliveryAddressesTableUpdateCompanionBuilder =
    DeliveryAddressesCompanion Function({
      Value<String> accountId,
      Value<String> fullName,
      Value<String> mobile,
      Value<String> line,
      Value<String> postcode,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$DeliveryAddressesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DeliveryAddressesTable,
          DeliveryAddressRow
        > {
  $$DeliveryAddressesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('delivery_addresses__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DeliveryAddressesTableFilterComposer
    extends Composer<_$AppDatabase, $DeliveryAddressesTable> {
  $$DeliveryAddressesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get line => $composableBuilder(
    column: $table.line,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postcode => $composableBuilder(
    column: $table.postcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeliveryAddressesTableOrderingComposer
    extends Composer<_$AppDatabase, $DeliveryAddressesTable> {
  $$DeliveryAddressesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get line => $composableBuilder(
    column: $table.line,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postcode => $composableBuilder(
    column: $table.postcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeliveryAddressesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeliveryAddressesTable> {
  $$DeliveryAddressesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get mobile =>
      $composableBuilder(column: $table.mobile, builder: (column) => column);

  GeneratedColumn<String> get line =>
      $composableBuilder(column: $table.line, builder: (column) => column);

  GeneratedColumn<String> get postcode =>
      $composableBuilder(column: $table.postcode, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeliveryAddressesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeliveryAddressesTable,
          DeliveryAddressRow,
          $$DeliveryAddressesTableFilterComposer,
          $$DeliveryAddressesTableOrderingComposer,
          $$DeliveryAddressesTableAnnotationComposer,
          $$DeliveryAddressesTableCreateCompanionBuilder,
          $$DeliveryAddressesTableUpdateCompanionBuilder,
          (DeliveryAddressRow, $$DeliveryAddressesTableReferences),
          DeliveryAddressRow,
          PrefetchHooks Function({bool accountId})
        > {
  $$DeliveryAddressesTableTableManager(
    _$AppDatabase db,
    $DeliveryAddressesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeliveryAddressesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeliveryAddressesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeliveryAddressesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> accountId = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> mobile = const Value.absent(),
                Value<String> line = const Value.absent(),
                Value<String> postcode = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeliveryAddressesCompanion(
                accountId: accountId,
                fullName: fullName,
                mobile: mobile,
                line: line,
                postcode: postcode,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String accountId,
                required String fullName,
                required String mobile,
                required String line,
                required String postcode,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DeliveryAddressesCompanion.insert(
                accountId: accountId,
                fullName: fullName,
                mobile: mobile,
                line: line,
                postcode: postcode,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DeliveryAddressesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable:
                                    $$DeliveryAddressesTableReferences
                                        ._accountIdTable(db),
                                referencedColumn:
                                    $$DeliveryAddressesTableReferences
                                        ._accountIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DeliveryAddressesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeliveryAddressesTable,
      DeliveryAddressRow,
      $$DeliveryAddressesTableFilterComposer,
      $$DeliveryAddressesTableOrderingComposer,
      $$DeliveryAddressesTableAnnotationComposer,
      $$DeliveryAddressesTableCreateCompanionBuilder,
      $$DeliveryAddressesTableUpdateCompanionBuilder,
      (DeliveryAddressRow, $$DeliveryAddressesTableReferences),
      DeliveryAddressRow,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$ShopOrdersTableCreateCompanionBuilder =
    ShopOrdersCompanion Function({
      required String id,
      required String accountId,
      required String status,
      required String fullName,
      required String mobile,
      required String addressLine,
      required String postcode,
      required int totalMinor,
      required String currency,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ShopOrdersTableUpdateCompanionBuilder =
    ShopOrdersCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> status,
      Value<String> fullName,
      Value<String> mobile,
      Value<String> addressLine,
      Value<String> postcode,
      Value<int> totalMinor,
      Value<String> currency,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ShopOrdersTableReferences
    extends BaseReferences<_$AppDatabase, $ShopOrdersTable, ShopOrderRow> {
  $$ShopOrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('shop_orders__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ShopOrderItemsTable, List<ShopOrderItemRow>>
  _shopOrderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.shopOrderItems,
    aliasName: 'shop_orders__id__shop_order_items__order_id',
  );

  $$ShopOrderItemsTableProcessedTableManager get shopOrderItemsRefs {
    final manager = $$ShopOrderItemsTableTableManager(
      $_db,
      $_db.shopOrderItems,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shopOrderItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShopOrdersTableFilterComposer
    extends Composer<_$AppDatabase, $ShopOrdersTable> {
  $$ShopOrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLine => $composableBuilder(
    column: $table.addressLine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postcode => $composableBuilder(
    column: $table.postcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> shopOrderItemsRefs(
    Expression<bool> Function($$ShopOrderItemsTableFilterComposer f) f,
  ) {
    final $$ShopOrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shopOrderItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShopOrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.shopOrderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShopOrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $ShopOrdersTable> {
  $$ShopOrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLine => $composableBuilder(
    column: $table.addressLine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postcode => $composableBuilder(
    column: $table.postcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShopOrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShopOrdersTable> {
  $$ShopOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get mobile =>
      $composableBuilder(column: $table.mobile, builder: (column) => column);

  GeneratedColumn<String> get addressLine => $composableBuilder(
    column: $table.addressLine,
    builder: (column) => column,
  );

  GeneratedColumn<String> get postcode =>
      $composableBuilder(column: $table.postcode, builder: (column) => column);

  GeneratedColumn<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> shopOrderItemsRefs<T extends Object>(
    Expression<T> Function($$ShopOrderItemsTableAnnotationComposer a) f,
  ) {
    final $$ShopOrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shopOrderItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShopOrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.shopOrderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShopOrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShopOrdersTable,
          ShopOrderRow,
          $$ShopOrdersTableFilterComposer,
          $$ShopOrdersTableOrderingComposer,
          $$ShopOrdersTableAnnotationComposer,
          $$ShopOrdersTableCreateCompanionBuilder,
          $$ShopOrdersTableUpdateCompanionBuilder,
          (ShopOrderRow, $$ShopOrdersTableReferences),
          ShopOrderRow,
          PrefetchHooks Function({bool accountId, bool shopOrderItemsRefs})
        > {
  $$ShopOrdersTableTableManager(_$AppDatabase db, $ShopOrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShopOrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShopOrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShopOrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> mobile = const Value.absent(),
                Value<String> addressLine = const Value.absent(),
                Value<String> postcode = const Value.absent(),
                Value<int> totalMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShopOrdersCompanion(
                id: id,
                accountId: accountId,
                status: status,
                fullName: fullName,
                mobile: mobile,
                addressLine: addressLine,
                postcode: postcode,
                totalMinor: totalMinor,
                currency: currency,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String status,
                required String fullName,
                required String mobile,
                required String addressLine,
                required String postcode,
                required int totalMinor,
                required String currency,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ShopOrdersCompanion.insert(
                id: id,
                accountId: accountId,
                status: status,
                fullName: fullName,
                mobile: mobile,
                addressLine: addressLine,
                postcode: postcode,
                totalMinor: totalMinor,
                currency: currency,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShopOrdersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({accountId = false, shopOrderItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (shopOrderItemsRefs) db.shopOrderItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accountId,
                                    referencedTable: $$ShopOrdersTableReferences
                                        ._accountIdTable(db),
                                    referencedColumn:
                                        $$ShopOrdersTableReferences
                                            ._accountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (shopOrderItemsRefs)
                        await $_getPrefetchedData<
                          ShopOrderRow,
                          $ShopOrdersTable,
                          ShopOrderItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$ShopOrdersTableReferences
                              ._shopOrderItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShopOrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).shopOrderItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ShopOrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShopOrdersTable,
      ShopOrderRow,
      $$ShopOrdersTableFilterComposer,
      $$ShopOrdersTableOrderingComposer,
      $$ShopOrdersTableAnnotationComposer,
      $$ShopOrdersTableCreateCompanionBuilder,
      $$ShopOrdersTableUpdateCompanionBuilder,
      (ShopOrderRow, $$ShopOrdersTableReferences),
      ShopOrderRow,
      PrefetchHooks Function({bool accountId, bool shopOrderItemsRefs})
    >;
typedef $$ShopOrderItemsTableCreateCompanionBuilder =
    ShopOrderItemsCompanion Function({
      required String id,
      required String orderId,
      required String productId,
      required String nameSnapshot,
      required String imageHint,
      required int unitPriceMinor,
      required String currency,
      required int quantity,
      Value<int> rowid,
    });
typedef $$ShopOrderItemsTableUpdateCompanionBuilder =
    ShopOrderItemsCompanion Function({
      Value<String> id,
      Value<String> orderId,
      Value<String> productId,
      Value<String> nameSnapshot,
      Value<String> imageHint,
      Value<int> unitPriceMinor,
      Value<String> currency,
      Value<int> quantity,
      Value<int> rowid,
    });

final class $$ShopOrderItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ShopOrderItemsTable, ShopOrderItemRow> {
  $$ShopOrderItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShopOrdersTable _orderIdTable(_$AppDatabase db) =>
      db.shopOrders.createAlias('shop_order_items__order_id__shop_orders__id');

  $$ShopOrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<String>('order_id')!;

    final manager = $$ShopOrdersTableTableManager(
      $_db,
      $_db.shopOrders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShopOrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShopOrderItemsTable> {
  $$ShopOrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageHint => $composableBuilder(
    column: $table.imageHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  $$ShopOrdersTableFilterComposer get orderId {
    final $$ShopOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.shopOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShopOrdersTableFilterComposer(
            $db: $db,
            $table: $db.shopOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShopOrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShopOrderItemsTable> {
  $$ShopOrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageHint => $composableBuilder(
    column: $table.imageHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShopOrdersTableOrderingComposer get orderId {
    final $$ShopOrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.shopOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShopOrdersTableOrderingComposer(
            $db: $db,
            $table: $db.shopOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShopOrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShopOrderItemsTable> {
  $$ShopOrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageHint =>
      $composableBuilder(column: $table.imageHint, builder: (column) => column);

  GeneratedColumn<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  $$ShopOrdersTableAnnotationComposer get orderId {
    final $$ShopOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.shopOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShopOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.shopOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShopOrderItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShopOrderItemsTable,
          ShopOrderItemRow,
          $$ShopOrderItemsTableFilterComposer,
          $$ShopOrderItemsTableOrderingComposer,
          $$ShopOrderItemsTableAnnotationComposer,
          $$ShopOrderItemsTableCreateCompanionBuilder,
          $$ShopOrderItemsTableUpdateCompanionBuilder,
          (ShopOrderItemRow, $$ShopOrderItemsTableReferences),
          ShopOrderItemRow,
          PrefetchHooks Function({bool orderId})
        > {
  $$ShopOrderItemsTableTableManager(
    _$AppDatabase db,
    $ShopOrderItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShopOrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShopOrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShopOrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> nameSnapshot = const Value.absent(),
                Value<String> imageHint = const Value.absent(),
                Value<int> unitPriceMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShopOrderItemsCompanion(
                id: id,
                orderId: orderId,
                productId: productId,
                nameSnapshot: nameSnapshot,
                imageHint: imageHint,
                unitPriceMinor: unitPriceMinor,
                currency: currency,
                quantity: quantity,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orderId,
                required String productId,
                required String nameSnapshot,
                required String imageHint,
                required int unitPriceMinor,
                required String currency,
                required int quantity,
                Value<int> rowid = const Value.absent(),
              }) => ShopOrderItemsCompanion.insert(
                id: id,
                orderId: orderId,
                productId: productId,
                nameSnapshot: nameSnapshot,
                imageHint: imageHint,
                unitPriceMinor: unitPriceMinor,
                currency: currency,
                quantity: quantity,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShopOrderItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (orderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.orderId,
                                referencedTable: $$ShopOrderItemsTableReferences
                                    ._orderIdTable(db),
                                referencedColumn:
                                    $$ShopOrderItemsTableReferences
                                        ._orderIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ShopOrderItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShopOrderItemsTable,
      ShopOrderItemRow,
      $$ShopOrderItemsTableFilterComposer,
      $$ShopOrderItemsTableOrderingComposer,
      $$ShopOrderItemsTableAnnotationComposer,
      $$ShopOrderItemsTableCreateCompanionBuilder,
      $$ShopOrderItemsTableUpdateCompanionBuilder,
      (ShopOrderItemRow, $$ShopOrderItemsTableReferences),
      ShopOrderItemRow,
      PrefetchHooks Function({bool orderId})
    >;
typedef $$ProductEnquiriesTableCreateCompanionBuilder =
    ProductEnquiriesCompanion Function({
      required String id,
      Value<String?> accountId,
      Value<String?> productId,
      required String message,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ProductEnquiriesTableUpdateCompanionBuilder =
    ProductEnquiriesCompanion Function({
      Value<String> id,
      Value<String?> accountId,
      Value<String?> productId,
      Value<String> message,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ProductEnquiriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProductEnquiriesTable,
          ProductEnquiryRow
        > {
  $$ProductEnquiriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('product_enquiries__account_id__accounts__id');

  $$AccountsTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<String>('account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProductEnquiriesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductEnquiriesTable> {
  $$ProductEnquiriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductEnquiriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductEnquiriesTable> {
  $$ProductEnquiriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductEnquiriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductEnquiriesTable> {
  $$ProductEnquiriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductEnquiriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductEnquiriesTable,
          ProductEnquiryRow,
          $$ProductEnquiriesTableFilterComposer,
          $$ProductEnquiriesTableOrderingComposer,
          $$ProductEnquiriesTableAnnotationComposer,
          $$ProductEnquiriesTableCreateCompanionBuilder,
          $$ProductEnquiriesTableUpdateCompanionBuilder,
          (ProductEnquiryRow, $$ProductEnquiriesTableReferences),
          ProductEnquiryRow,
          PrefetchHooks Function({bool accountId})
        > {
  $$ProductEnquiriesTableTableManager(
    _$AppDatabase db,
    $ProductEnquiriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductEnquiriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductEnquiriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductEnquiriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductEnquiriesCompanion(
                id: id,
                accountId: accountId,
                productId: productId,
                message: message,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> accountId = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                required String message,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ProductEnquiriesCompanion.insert(
                id: id,
                accountId: accountId,
                productId: productId,
                message: message,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductEnquiriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable:
                                    $$ProductEnquiriesTableReferences
                                        ._accountIdTable(db),
                                referencedColumn:
                                    $$ProductEnquiriesTableReferences
                                        ._accountIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProductEnquiriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductEnquiriesTable,
      ProductEnquiryRow,
      $$ProductEnquiriesTableFilterComposer,
      $$ProductEnquiriesTableOrderingComposer,
      $$ProductEnquiriesTableAnnotationComposer,
      $$ProductEnquiriesTableCreateCompanionBuilder,
      $$ProductEnquiriesTableUpdateCompanionBuilder,
      (ProductEnquiryRow, $$ProductEnquiriesTableReferences),
      ProductEnquiryRow,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$AppMetaTableCreateCompanionBuilder =
    AppMetaCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppMetaTableUpdateCompanionBuilder =
    AppMetaCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppMetaTableFilterComposer
    extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppMetaTable,
          AppMetaRow,
          $$AppMetaTableFilterComposer,
          $$AppMetaTableOrderingComposer,
          $$AppMetaTableAnnotationComposer,
          $$AppMetaTableCreateCompanionBuilder,
          $$AppMetaTableUpdateCompanionBuilder,
          (
            AppMetaRow,
            BaseReferences<_$AppDatabase, $AppMetaTable, AppMetaRow>,
          ),
          AppMetaRow,
          PrefetchHooks Function()
        > {
  $$AppMetaTableTableManager(_$AppDatabase db, $AppMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppMetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) =>
                  AppMetaCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppMetaTable,
      AppMetaRow,
      $$AppMetaTableFilterComposer,
      $$AppMetaTableOrderingComposer,
      $$AppMetaTableAnnotationComposer,
      $$AppMetaTableCreateCompanionBuilder,
      $$AppMetaTableUpdateCompanionBuilder,
      (AppMetaRow, BaseReferences<_$AppDatabase, $AppMetaTable, AppMetaRow>),
      AppMetaRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$OtpChallengesTableTableManager get otpChallenges =>
      $$OtpChallengesTableTableManager(_db, _db.otpChallenges);
  $$AuthSessionsTableTableManager get authSessions =>
      $$AuthSessionsTableTableManager(_db, _db.authSessions);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$MilestonesTableTableManager get milestones =>
      $$MilestonesTableTableManager(_db, _db.milestones);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$CartsTableTableManager get carts =>
      $$CartsTableTableManager(_db, _db.carts);
  $$CartItemsTableTableManager get cartItems =>
      $$CartItemsTableTableManager(_db, _db.cartItems);
  $$SiteUpdatesTableTableManager get siteUpdates =>
      $$SiteUpdatesTableTableManager(_db, _db.siteUpdates);
  $$AssetsTableTableManager get assets =>
      $$AssetsTableTableManager(_db, _db.assets);
  $$SiteUpdateAssetsTableTableManager get siteUpdateAssets =>
      $$SiteUpdateAssetsTableTableManager(_db, _db.siteUpdateAssets);
  $$ProjectBalancesTableTableManager get projectBalances =>
      $$ProjectBalancesTableTableManager(_db, _db.projectBalances);
  $$LedgerEntriesTableTableManager get ledgerEntries =>
      $$LedgerEntriesTableTableManager(_db, _db.ledgerEntries);
  $$DueScheduleItemsTableTableManager get dueScheduleItems =>
      $$DueScheduleItemsTableTableManager(_db, _db.dueScheduleItems);
  $$ProjectDocumentsTableTableManager get projectDocuments =>
      $$ProjectDocumentsTableTableManager(_db, _db.projectDocuments);
  $$DesignsTableTableManager get designs =>
      $$DesignsTableTableManager(_db, _db.designs);
  $$DesignAssetsTableTableManager get designAssets =>
      $$DesignAssetsTableTableManager(_db, _db.designAssets);
  $$SupportQueriesTableTableManager get supportQueries =>
      $$SupportQueriesTableTableManager(_db, _db.supportQueries);
  $$DevicesTableTableManager get devices =>
      $$DevicesTableTableManager(_db, _db.devices);
  $$InAppNotificationsTableTableManager get inAppNotifications =>
      $$InAppNotificationsTableTableManager(_db, _db.inAppNotifications);
  $$DeliveryAddressesTableTableManager get deliveryAddresses =>
      $$DeliveryAddressesTableTableManager(_db, _db.deliveryAddresses);
  $$ShopOrdersTableTableManager get shopOrders =>
      $$ShopOrdersTableTableManager(_db, _db.shopOrders);
  $$ShopOrderItemsTableTableManager get shopOrderItems =>
      $$ShopOrderItemsTableTableManager(_db, _db.shopOrderItems);
  $$ProductEnquiriesTableTableManager get productEnquiries =>
      $$ProductEnquiriesTableTableManager(_db, _db.productEnquiries);
  $$AppMetaTableTableManager get appMeta =>
      $$AppMetaTableTableManager(_db, _db.appMeta);
}
