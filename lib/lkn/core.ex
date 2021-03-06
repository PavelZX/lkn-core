#
# lkn.core: an entity-component-system (ecs) implementation for lyxan
# Copyright (C) 2017 Thomas Letan <contact@thomasletan.fr>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
defmodule Lkn.Core do
  defmodule Name do
    @moduledoc false

    @type t :: term

    alias Lkn.Core.Entity
    alias Lkn.Core.Map
    alias Lkn.Core.Entity
    alias Lkn.Core.Instance
    alias Lkn.Core.System

    @spec properties(Entity.k) :: t
    def properties(entity_key) do
      {:via, Registry, {Lkn.Core.Registry, {:entity, entity_key, :props}}}
    end

    @spec component(Entity.k, System.m) :: t
    def component(entity_key, system) do
      {:via, Registry, {Lkn.Core.Registry, {:entity, entity_key, system}}}
    end

    @spec comps_list(Entity.k) :: t
    def comps_list(entity_key) do
      {:via, Registry, {Lkn.Core.Registry, {:entity, entity_key, :comps_list}}}
    end

    @spec entity(Entity.k) :: t
    def entity(entity_key) do
      {:via, Registry, {Lkn.Core.Registry, {:entity, entity_key}}}
    end

    @spec system(Instance.k, System.m) :: t
    def system(instance_key, sys) do
      {:via, Registry, {Lkn.Core.Registry, {:engine, instance_key, sys}}}
    end

    @spec instance(Instance.k) :: t
    def instance(instance_key) do
      {:via, Registry, {Lkn.Core.Registry, {:instance, instance_key}}}
    end

    @spec puppeteer(Puppeteer.k) :: t
    def puppeteer(puppeteer_key) do
      {:via, Registry, {Lkn.Core.Registry, {:puppeteer, puppeteer_key}}}
    end

    @spec pool(Map.k) :: t
    def pool(map_key) do
      {:via, Registry, {Lkn.Core.Registry, {:pool, map_key}}}
    end

    @spec instance_sup(Map.k) :: t
    def instance_sup(map_key) do
      {:via, Registry, {Lkn.Core.Registry, {:pool, map_key, :sup}}}
    end
  end

  use Application

  import Supervisor.Spec

  @doc false
  def start(_type, _args) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @doc false
  @spec init(any) ::
  {:ok, {:supervisor.sup_flags, [Supervisor.Spec.spec]}} |
  :ignore
  def init(_) do
    children = [
      supervisor(Registry, [:unique, Lkn.Core.Registry], id: :core_registry),
      supervisor(Lkn.Core.Pool.Supervisor, [])
    ]

    supervise(children, strategy: :one_for_all)
  end
end
