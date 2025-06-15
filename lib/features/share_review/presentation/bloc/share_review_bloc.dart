import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_airlines.dart';
import '../../domain/usecases/get_airports.dart';
import 'share_review_event.dart';
import 'share_review_state.dart';

class ShareReviewBloc extends Bloc<ShareReviewEvent, ShareReviewState> {
  final GetAirlines getAirlines;
  final GetAirports getAirports;

  ShareReviewBloc({
    required this.getAirlines,
    required this.getAirports,
  }) : super(ShareReviewInitial()) {
    on<LoadAirlinesEvent>(_onLoadAirlines);
    on<LoadAirportsEvent>(_onLoadAirports);
    on<SubmitReviewEvent>(_onSubmitReview);
    on<ResetFormEvent>(_onResetForm);
  }

  void _onLoadAirlines(
      LoadAirlinesEvent event, Emitter<ShareReviewState> emit) async {
    emit(ShareReviewLoading());

    final failureOrAirlines = await getAirlines(search: event.search);

    failureOrAirlines.fold(
      (failure) =>
          emit(ShareReviewError(message: _mapFailureToMessage(failure))),
      (airlines) => emit(AirlinesLoaded(airlines: airlines)),
    );
  }

  void _onLoadAirports(
      LoadAirportsEvent event, Emitter<ShareReviewState> emit) async {
    emit(ShareReviewLoading());

    final failureOrAirports = await getAirports(search: event.search);

    failureOrAirports.fold(
      (failure) =>
          emit(ShareReviewError(message: _mapFailureToMessage(failure))),
      (airports) => emit(AirportsLoaded(airports: airports)),
    );
  }

  void _onSubmitReview(
      SubmitReviewEvent event, Emitter<ShareReviewState> emit) async {
    emit(ShareReviewLoading());

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    emit(ReviewSubmitted());
  }

  void _onResetForm(ResetFormEvent event, Emitter<ShareReviewState> emit) {
    emit(ShareReviewInitial());
  }

  String _mapFailureToMessage(failure) {
    if (failure is ServerFailure) {
      return 'Server Error';
    } else if (failure is NetworkFailure) {
      return 'Network Error';
    } else {
      return 'Unexpected Error';
    }
  }
}
