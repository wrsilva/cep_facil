import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cep_facil/core/error/failures.dart';
import 'package:cep_facil/features/cep/domain/usecases/search_cep_usecase.dart';
import 'package:cep_facil/features/cep/presentation/cubits/cep_state.dart';

class CepCubit extends Cubit<CepState> {
  CepCubit(this._searchCepUsecase) : super(const CepInitial());

  final SearchCepUsecase _searchCepUsecase;

  Future<void> searchCep(String cep) async {
    emit(const CepLoading());
    try {
      final entity = await _searchCepUsecase(cep);
      emit(CepSuccess(entity));
    } on ServerFailure catch (e) {
      emit(CepFailure(e.message));
    } on NetworkFailure catch (e) {
      emit(CepFailure(e.message));
    } catch (_) {
      emit(const CepFailure('Erro inesperado. Tente novamente.'));
    }
  }
}
