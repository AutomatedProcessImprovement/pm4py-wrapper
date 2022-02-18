import os
from pathlib import Path

import pytest
from click.testing import CliRunner


@pytest.fixture(scope='function')
def runner() -> CliRunner:
    return CliRunner()


@pytest.fixture(scope='module')
def entry_point() -> Path:
    if os.path.basename(os.getcwd()) == 'tests':
        return Path('assets')
    else:
        return Path('tests/assets')
