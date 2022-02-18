from pathlib import Path
from typing import List

import pytest

from pm4py_wrapper.cli import main


@pytest.fixture
def xes_paths(entry_point) -> List[Path]:
    return [
        entry_point / 'input/PurchasingExample.xes',
        entry_point / 'input/Production.xes',
        entry_point / 'input/BPI_Challenge_2012_W_Two_TS.xes',
    ]


@pytest.fixture
def csv_paths(entry_point) -> List[Path]:
    return [
        entry_point / 'input/PurchasingExample.csv',
        entry_point / 'input/Production.csv',
        entry_point / 'input/BPI_Challenge_2012_W_Two_TS.csv',
    ]


def test_xes_to_csv(runner, entry_point, xes_paths):
    for arg in xes_paths:
        output_dir = arg.parent.parent / 'output'
        result = runner.invoke(
            main, ['--input_log', str(arg), '--output_dir', str(output_dir), 'xes-to-csv'])
        output_path = output_dir / arg.with_suffix('.csv').name
        assert result.exit_code == 0
        assert output_path.exists()
        output_path.unlink()


def test_csv_to_xes(runner, entry_point, csv_paths):
    for arg in csv_paths:
        output_dir = arg.parent.parent / 'output'
        result = runner.invoke(
            main, ['--input_log', str(arg), '--output_dir', str(output_dir), 'csv-to-xes'])
        output_path = output_dir / arg.with_suffix('.xes').name
        assert result.exit_code == 0
        assert output_path.exists()
        output_path.unlink()

