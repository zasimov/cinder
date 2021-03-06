# Copyright (C) 2013 Deutsche Telekom AG
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

"""Base class for all backup drivers."""

from cinder.db import base


class BackupDriver(base.Base):

    def backup(self, backup, volume_file):
        """Start a backup of a specified volume."""
        raise NotImplementedError()

    def restore(self, backup, volume_id, volume_file):
        """Restore a saved backup."""
        raise NotImplementedError()

    def delete(self, backup):
        """Delete a saved backup."""
        raise NotImplementedError()
