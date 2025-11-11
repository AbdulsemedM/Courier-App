// ignore_for_file: public_member_api_docs, sort_constructors_first

class AnalyticsDashboardModel {
  final String? fromDate;
  final String? toDate;
  final int? branchId;
  final int? totalShipmentsToday;
  final int? totalShipmentsThisWeek;
  final int? deliveriesInTransit;
  final int? completedDeliveries;
  final int? pendingDeliveries;
  final int? delayedDeliveries;
  final double? revenue;
  final double? expenses;
  final double? profit;
  final int? activeDrivers;
  final int? activeCustomers;
  final FinancialOverview? financialOverview;
  final Totals? totals;
  final ShipmentOverview? shipmentOverview;
  final TargetKg? targetKg;
  final TopItems? topItems;
  final CharityCalculation? charityCalculation;
  final List<DeliveryPerDay>? deliveriesPerDay;
  final List<DeliveryLocation>? deliveryLocations;
  final List<EarningsOverTime>? earningsOverTime;
  final List<AverageDeliveryTime>? averageDeliveryTime;

  AnalyticsDashboardModel({
    this.fromDate,
    this.toDate,
    this.branchId,
    this.totalShipmentsToday,
    this.totalShipmentsThisWeek,
    this.deliveriesInTransit,
    this.completedDeliveries,
    this.pendingDeliveries,
    this.delayedDeliveries,
    this.revenue,
    this.expenses,
    this.profit,
    this.activeDrivers,
    this.activeCustomers,
    this.financialOverview,
    this.totals,
    this.shipmentOverview,
    this.targetKg,
    this.topItems,
    this.charityCalculation,
    this.deliveriesPerDay,
    this.deliveryLocations,
    this.earningsOverTime,
    this.averageDeliveryTime,
  });

  factory AnalyticsDashboardModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsDashboardModel(
      fromDate: json['fromDate'] as String?,
      toDate: json['toDate'] as String?,
      branchId: json['branchId'] as int?,
      totalShipmentsToday: json['totalShipmentsToday'] as int?,
      totalShipmentsThisWeek: json['totalShipmentsThisWeek'] as int?,
      deliveriesInTransit: json['deliveriesInTransit'] as int?,
      completedDeliveries: json['completedDeliveries'] as int?,
      pendingDeliveries: json['pendingDeliveries'] as int?,
      delayedDeliveries: json['delayedDeliveries'] as int?,
      revenue: json['revenue'] != null
          ? double.tryParse(json['revenue'].toString())
          : null,
      expenses: json['expenses'] != null
          ? double.tryParse(json['expenses'].toString())
          : null,
      profit: json['profit'] != null
          ? double.tryParse(json['profit'].toString())
          : null,
      activeDrivers: json['activeDrivers'] as int?,
      activeCustomers: json['activeCustomers'] as int?,
      financialOverview: json['financialOverview'] != null
          ? FinancialOverview.fromJson(
              json['financialOverview'] as Map<String, dynamic>)
          : null,
      totals: json['totals'] != null
          ? Totals.fromJson(json['totals'] as Map<String, dynamic>)
          : null,
      shipmentOverview: json['shipmentOverview'] != null
          ? ShipmentOverview.fromJson(
              json['shipmentOverview'] as Map<String, dynamic>)
          : null,
      targetKg: json['targetKg'] != null
          ? TargetKg.fromJson(json['targetKg'] as Map<String, dynamic>)
          : null,
      topItems: json['topItems'] != null
          ? TopItems.fromJson(json['topItems'] as Map<String, dynamic>)
          : null,
      charityCalculation: json['charityCalculation'] != null
          ? CharityCalculation.fromJson(
              json['charityCalculation'] as Map<String, dynamic>)
          : null,
      deliveriesPerDay: json['deliveriesPerDay'] != null
          ? (json['deliveriesPerDay'] as List)
              .map((e) => DeliveryPerDay.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      deliveryLocations: json['deliveryLocations'] != null
          ? (json['deliveryLocations'] as List)
              .map((e) => DeliveryLocation.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      earningsOverTime: json['earningsOverTime'] != null
          ? (json['earningsOverTime'] as List)
              .map((e) => EarningsOverTime.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      averageDeliveryTime: json['averageDeliveryTime'] != null
          ? (json['averageDeliveryTime'] as List)
              .map((e) =>
                  AverageDeliveryTime.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromDate': fromDate,
      'toDate': toDate,
      'branchId': branchId,
      'totalShipmentsToday': totalShipmentsToday,
      'totalShipmentsThisWeek': totalShipmentsThisWeek,
      'deliveriesInTransit': deliveriesInTransit,
      'completedDeliveries': completedDeliveries,
      'pendingDeliveries': pendingDeliveries,
      'delayedDeliveries': delayedDeliveries,
      'revenue': revenue,
      'expenses': expenses,
      'profit': profit,
      'activeDrivers': activeDrivers,
      'activeCustomers': activeCustomers,
      'financialOverview': financialOverview?.toJson(),
      'totals': totals?.toJson(),
      'shipmentOverview': shipmentOverview?.toJson(),
      'targetKg': targetKg?.toJson(),
      'topItems': topItems?.toJson(),
      'charityCalculation': charityCalculation?.toJson(),
      'deliveriesPerDay': deliveriesPerDay?.map((e) => e.toJson()).toList(),
      'deliveryLocations': deliveryLocations?.map((e) => e.toJson()).toList(),
      'earningsOverTime': earningsOverTime?.map((e) => e.toJson()).toList(),
      'averageDeliveryTime':
          averageDeliveryTime?.map((e) => e.toJson()).toList(),
    };
  }
}

class FinancialOverview {
  final FinancialPeriod? today;
  final FinancialPeriod? week;
  final FinancialPeriod? month;

  FinancialOverview({
    this.today,
    this.week,
    this.month,
  });

  factory FinancialOverview.fromJson(Map<String, dynamic> json) {
    return FinancialOverview(
      today: json['today'] != null
          ? FinancialPeriod.fromJson(json['today'] as Map<String, dynamic>)
          : null,
      week: json['week'] != null
          ? FinancialPeriod.fromJson(json['week'] as Map<String, dynamic>)
          : null,
      month: json['month'] != null
          ? FinancialPeriod.fromJson(json['month'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'today': today?.toJson(),
      'week': week?.toJson(),
      'month': month?.toJson(),
    };
  }
}

class FinancialPeriod {
  final double? cash;
  final double? cod;
  final double? expenses;
  final double? expectedNetCash;

  FinancialPeriod({
    this.cash,
    this.cod,
    this.expenses,
    this.expectedNetCash,
  });

  factory FinancialPeriod.fromJson(Map<String, dynamic> json) {
    return FinancialPeriod(
      cash: json['cash'] != null
          ? double.tryParse(json['cash'].toString())
          : null,
      cod: json['cod'] != null ? double.tryParse(json['cod'].toString()) : null,
      expenses: json['expenses'] != null
          ? double.tryParse(json['expenses'].toString())
          : null,
      expectedNetCash: json['expectedNetCash'] != null
          ? double.tryParse(json['expectedNetCash'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cash': cash,
      'cod': cod,
      'expenses': expenses,
      'expectedNetCash': expectedNetCash,
    };
  }
}

class Totals {
  final double? totalCash;
  final double? totalCod;
  final double? totalExpenses;
  final double? totalNetCash;

  Totals({
    this.totalCash,
    this.totalCod,
    this.totalExpenses,
    this.totalNetCash,
  });

  factory Totals.fromJson(Map<String, dynamic> json) {
    return Totals(
      totalCash: json['totalCash'] != null
          ? double.tryParse(json['totalCash'].toString())
          : null,
      totalCod: json['totalCod'] != null
          ? double.tryParse(json['totalCod'].toString())
          : null,
      totalExpenses: json['totalExpenses'] != null
          ? double.tryParse(json['totalExpenses'].toString())
          : null,
      totalNetCash: json['totalNetCash'] != null
          ? double.tryParse(json['totalNetCash'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCash': totalCash,
      'totalCod': totalCod,
      'totalExpenses': totalExpenses,
      'totalNetCash': totalNetCash,
    };
  }
}

class ShipmentOverview {
  final int? shipments;
  final int? completed;
  final int? inTransit;
  final int? pending;

  ShipmentOverview({
    this.shipments,
    this.completed,
    this.inTransit,
    this.pending,
  });

  factory ShipmentOverview.fromJson(Map<String, dynamic> json) {
    return ShipmentOverview(
      shipments: json['shipments'] as int?,
      completed: json['completed'] as int?,
      inTransit: json['inTransit'] as int?,
      pending: json['pending'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shipments': shipments,
      'completed': completed,
      'inTransit': inTransit,
      'pending': pending,
    };
  }
}

class TargetKg {
  final TargetPeriod? daily;
  final TargetPeriod? weekly;
  final TargetPeriod? monthly;

  TargetKg({
    this.daily,
    this.weekly,
    this.monthly,
  });

  factory TargetKg.fromJson(Map<String, dynamic> json) {
    return TargetKg(
      daily: json['daily'] != null
          ? TargetPeriod.fromJson(json['daily'] as Map<String, dynamic>)
          : null,
      weekly: json['weekly'] != null
          ? TargetPeriod.fromJson(json['weekly'] as Map<String, dynamic>)
          : null,
      monthly: json['monthly'] != null
          ? TargetPeriod.fromJson(json['monthly'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daily': daily?.toJson(),
      'weekly': weekly?.toJson(),
      'monthly': monthly?.toJson(),
    };
  }
}

class TargetPeriod {
  final int? progress;
  final int? target;
  final double? percentage;
  final String? status;

  TargetPeriod({
    this.progress,
    this.target,
    this.percentage,
    this.status,
  });

  factory TargetPeriod.fromJson(Map<String, dynamic> json) {
    return TargetPeriod(
      progress: json['progress'] as int?,
      target: json['target'] as int?,
      percentage: json['percentage'] != null
          ? double.tryParse(json['percentage'].toString())
          : null,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'progress': progress,
      'target': target,
      'percentage': percentage,
      'status': status,
    };
  }
}

class TopItems {
  final int? totalShipments;
  final int? others;
  final int? valuableShipments;
  final int? delayed;

  TopItems({
    this.totalShipments,
    this.others,
    this.valuableShipments,
    this.delayed,
  });

  factory TopItems.fromJson(Map<String, dynamic> json) {
    return TopItems(
      totalShipments: json['totalShipments'] as int?,
      others: json['others'] as int?,
      valuableShipments: json['valuableShipments'] as int?,
      delayed: json['delayed'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalShipments': totalShipments,
      'others': others,
      'valuableShipments': valuableShipments,
      'delayed': delayed,
    };
  }
}

class CharityCalculation {
  final double? totalCashAwbsKg;
  final double? totalCodAwbsKg;
  final double? totalKgHandled;
  final double? charityAmount;

  CharityCalculation({
    this.totalCashAwbsKg,
    this.totalCodAwbsKg,
    this.totalKgHandled,
    this.charityAmount,
  });

  factory CharityCalculation.fromJson(Map<String, dynamic> json) {
    return CharityCalculation(
      totalCashAwbsKg: json['totalCashAwbsKg'] != null
          ? double.tryParse(json['totalCashAwbsKg'].toString())
          : null,
      totalCodAwbsKg: json['totalCodAwbsKg'] != null
          ? double.tryParse(json['totalCodAwbsKg'].toString())
          : null,
      totalKgHandled: json['totalKgHandled'] != null
          ? double.tryParse(json['totalKgHandled'].toString())
          : null,
      charityAmount: json['charityAmount'] != null
          ? double.tryParse(json['charityAmount'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCashAwbsKg': totalCashAwbsKg,
      'totalCodAwbsKg': totalCodAwbsKg,
      'totalKgHandled': totalKgHandled,
      'charityAmount': charityAmount,
    };
  }
}

class DeliveryPerDay {
  final String? date;
  final int? deliveries;
  final double? revenue;

  DeliveryPerDay({
    this.date,
    this.deliveries,
    this.revenue,
  });

  factory DeliveryPerDay.fromJson(Map<String, dynamic> json) {
    return DeliveryPerDay(
      date: json['date'] as String?,
      deliveries: json['deliveries'] as int?,
      revenue: json['revenue'] != null
          ? double.tryParse(json['revenue'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'deliveries': deliveries,
      'revenue': revenue,
    };
  }
}

class DeliveryLocation {
  final String? location;
  final int? count;
  final double? percentage;

  DeliveryLocation({
    this.location,
    this.count,
    this.percentage,
  });

  factory DeliveryLocation.fromJson(Map<String, dynamic> json) {
    return DeliveryLocation(
      location: json['location'] as String?,
      count: json['count'] as int?,
      percentage: json['percentage'] != null
          ? double.tryParse(json['percentage'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'count': count,
      'percentage': percentage,
    };
  }
}

class EarningsOverTime {
  final String? period;
  final double? revenue;
  final double? expenses;
  final double? profit;

  EarningsOverTime({
    this.period,
    this.revenue,
    this.expenses,
    this.profit,
  });

  factory EarningsOverTime.fromJson(Map<String, dynamic> json) {
    return EarningsOverTime(
      period: json['period'] as String?,
      revenue: json['revenue'] != null
          ? double.tryParse(json['revenue'].toString())
          : null,
      expenses: json['expenses'] != null
          ? double.tryParse(json['expenses'].toString())
          : null,
      profit: json['profit'] != null
          ? double.tryParse(json['profit'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'period': period,
      'revenue': revenue,
      'expenses': expenses,
      'profit': profit,
    };
  }
}

class AverageDeliveryTime {
  final String? timeRange;
  final int? count;
  final double? percentage;

  AverageDeliveryTime({
    this.timeRange,
    this.count,
    this.percentage,
  });

  factory AverageDeliveryTime.fromJson(Map<String, dynamic> json) {
    return AverageDeliveryTime(
      timeRange: json['timeRange'] as String?,
      count: json['count'] as int?,
      percentage: json['percentage'] != null
          ? double.tryParse(json['percentage'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timeRange': timeRange,
      'count': count,
      'percentage': percentage,
    };
  }
}
