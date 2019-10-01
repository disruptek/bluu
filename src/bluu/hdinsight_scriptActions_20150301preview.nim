
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: HDInsightManagementClient
## version: 2015-03-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The HDInsight Management Client.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "hdinsight-scriptActions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClustersExecuteScriptActions_567879 = ref object of OpenApiRestCall_567657
proc url_ClustersExecuteScriptActions_567881(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.HDInsight/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/executeScriptActions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersExecuteScriptActions_567880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Executes script actions on the specified HDInsight cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568071 = path.getOrDefault("clusterName")
  valid_568071 = validateParameter(valid_568071, JString, required = true,
                                 default = nil)
  if valid_568071 != nil:
    section.add "clusterName", valid_568071
  var valid_568072 = path.getOrDefault("resourceGroupName")
  valid_568072 = validateParameter(valid_568072, JString, required = true,
                                 default = nil)
  if valid_568072 != nil:
    section.add "resourceGroupName", valid_568072
  var valid_568073 = path.getOrDefault("subscriptionId")
  valid_568073 = validateParameter(valid_568073, JString, required = true,
                                 default = nil)
  if valid_568073 != nil:
    section.add "subscriptionId", valid_568073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The HDInsight client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568074 = query.getOrDefault("api-version")
  valid_568074 = validateParameter(valid_568074, JString, required = true,
                                 default = nil)
  if valid_568074 != nil:
    section.add "api-version", valid_568074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for executing script actions.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568098: Call_ClustersExecuteScriptActions_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes script actions on the specified HDInsight cluster.
  ## 
  let valid = call_568098.validator(path, query, header, formData, body)
  let scheme = call_568098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568098.url(scheme.get, call_568098.host, call_568098.base,
                         call_568098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568098, url, valid)

proc call*(call_568169: Call_ClustersExecuteScriptActions_567879;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## clustersExecuteScriptActions
  ## Executes script actions on the specified HDInsight cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The HDInsight client API Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The parameters for executing script actions.
  var path_568170 = newJObject()
  var query_568172 = newJObject()
  var body_568173 = newJObject()
  add(path_568170, "clusterName", newJString(clusterName))
  add(path_568170, "resourceGroupName", newJString(resourceGroupName))
  add(query_568172, "api-version", newJString(apiVersion))
  add(path_568170, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568173 = parameters
  result = call_568169.call(path_568170, query_568172, nil, nil, body_568173)

var clustersExecuteScriptActions* = Call_ClustersExecuteScriptActions_567879(
    name: "clustersExecuteScriptActions", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HDInsight/clusters/{clusterName}/executeScriptActions",
    validator: validate_ClustersExecuteScriptActions_567880, base: "",
    url: url_ClustersExecuteScriptActions_567881, schemes: {Scheme.Https})
type
  Call_ScriptActionsListPersistedScripts_568212 = ref object of OpenApiRestCall_567657
proc url_ScriptActionsListPersistedScripts_568214(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.HDInsight/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/scriptActions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptActionsListPersistedScripts_568213(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the persisted script actions for the specified cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568215 = path.getOrDefault("clusterName")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "clusterName", valid_568215
  var valid_568216 = path.getOrDefault("resourceGroupName")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "resourceGroupName", valid_568216
  var valid_568217 = path.getOrDefault("subscriptionId")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "subscriptionId", valid_568217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The HDInsight client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568218 = query.getOrDefault("api-version")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "api-version", valid_568218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568219: Call_ScriptActionsListPersistedScripts_568212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the persisted script actions for the specified cluster.
  ## 
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_ScriptActionsListPersistedScripts_568212;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## scriptActionsListPersistedScripts
  ## Lists all the persisted script actions for the specified cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The HDInsight client API Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568221 = newJObject()
  var query_568222 = newJObject()
  add(path_568221, "clusterName", newJString(clusterName))
  add(path_568221, "resourceGroupName", newJString(resourceGroupName))
  add(query_568222, "api-version", newJString(apiVersion))
  add(path_568221, "subscriptionId", newJString(subscriptionId))
  result = call_568220.call(path_568221, query_568222, nil, nil, nil)

var scriptActionsListPersistedScripts* = Call_ScriptActionsListPersistedScripts_568212(
    name: "scriptActionsListPersistedScripts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HDInsight/clusters/{clusterName}/scriptActions",
    validator: validate_ScriptActionsListPersistedScripts_568213, base: "",
    url: url_ScriptActionsListPersistedScripts_568214, schemes: {Scheme.Https})
type
  Call_ScriptActionsDelete_568223 = ref object of OpenApiRestCall_567657
proc url_ScriptActionsDelete_568225(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "scriptName" in path, "`scriptName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.HDInsight/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/scriptActions/"),
               (kind: VariableSegment, value: "scriptName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptActionsDelete_568224(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a specified persisted script action of the cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   scriptName: JString (required)
  ##             : The name of the script.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568226 = path.getOrDefault("clusterName")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "clusterName", valid_568226
  var valid_568227 = path.getOrDefault("resourceGroupName")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "resourceGroupName", valid_568227
  var valid_568228 = path.getOrDefault("subscriptionId")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "subscriptionId", valid_568228
  var valid_568229 = path.getOrDefault("scriptName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "scriptName", valid_568229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The HDInsight client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568230 = query.getOrDefault("api-version")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "api-version", valid_568230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568231: Call_ScriptActionsDelete_568223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a specified persisted script action of the cluster.
  ## 
  let valid = call_568231.validator(path, query, header, formData, body)
  let scheme = call_568231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568231.url(scheme.get, call_568231.host, call_568231.base,
                         call_568231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568231, url, valid)

proc call*(call_568232: Call_ScriptActionsDelete_568223; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          scriptName: string): Recallable =
  ## scriptActionsDelete
  ## Deletes a specified persisted script action of the cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The HDInsight client API Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   scriptName: string (required)
  ##             : The name of the script.
  var path_568233 = newJObject()
  var query_568234 = newJObject()
  add(path_568233, "clusterName", newJString(clusterName))
  add(path_568233, "resourceGroupName", newJString(resourceGroupName))
  add(query_568234, "api-version", newJString(apiVersion))
  add(path_568233, "subscriptionId", newJString(subscriptionId))
  add(path_568233, "scriptName", newJString(scriptName))
  result = call_568232.call(path_568233, query_568234, nil, nil, nil)

var scriptActionsDelete* = Call_ScriptActionsDelete_568223(
    name: "scriptActionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HDInsight/clusters/{clusterName}/scriptActions/{scriptName}",
    validator: validate_ScriptActionsDelete_568224, base: "",
    url: url_ScriptActionsDelete_568225, schemes: {Scheme.Https})
type
  Call_ScriptExecutionHistoryList_568235 = ref object of OpenApiRestCall_567657
proc url_ScriptExecutionHistoryList_568237(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.HDInsight/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/scriptExecutionHistory")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptExecutionHistoryList_568236(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all scripts' execution history for the specified cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568238 = path.getOrDefault("clusterName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "clusterName", valid_568238
  var valid_568239 = path.getOrDefault("resourceGroupName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "resourceGroupName", valid_568239
  var valid_568240 = path.getOrDefault("subscriptionId")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "subscriptionId", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The HDInsight client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568241 = query.getOrDefault("api-version")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "api-version", valid_568241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568242: Call_ScriptExecutionHistoryList_568235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all scripts' execution history for the specified cluster.
  ## 
  let valid = call_568242.validator(path, query, header, formData, body)
  let scheme = call_568242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568242.url(scheme.get, call_568242.host, call_568242.base,
                         call_568242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568242, url, valid)

proc call*(call_568243: Call_ScriptExecutionHistoryList_568235;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## scriptExecutionHistoryList
  ## Lists all scripts' execution history for the specified cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The HDInsight client API Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568244 = newJObject()
  var query_568245 = newJObject()
  add(path_568244, "clusterName", newJString(clusterName))
  add(path_568244, "resourceGroupName", newJString(resourceGroupName))
  add(query_568245, "api-version", newJString(apiVersion))
  add(path_568244, "subscriptionId", newJString(subscriptionId))
  result = call_568243.call(path_568244, query_568245, nil, nil, nil)

var scriptExecutionHistoryList* = Call_ScriptExecutionHistoryList_568235(
    name: "scriptExecutionHistoryList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HDInsight/clusters/{clusterName}/scriptExecutionHistory",
    validator: validate_ScriptExecutionHistoryList_568236, base: "",
    url: url_ScriptExecutionHistoryList_568237, schemes: {Scheme.Https})
type
  Call_ScriptActionsGetExecutionDetail_568246 = ref object of OpenApiRestCall_567657
proc url_ScriptActionsGetExecutionDetail_568248(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "scriptExecutionId" in path,
        "`scriptExecutionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.HDInsight/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/scriptExecutionHistory/"),
               (kind: VariableSegment, value: "scriptExecutionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptActionsGetExecutionDetail_568247(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the script execution detail for the given script execution ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   scriptExecutionId: JString (required)
  ##                    : The script execution Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568249 = path.getOrDefault("clusterName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "clusterName", valid_568249
  var valid_568250 = path.getOrDefault("resourceGroupName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "resourceGroupName", valid_568250
  var valid_568251 = path.getOrDefault("subscriptionId")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "subscriptionId", valid_568251
  var valid_568252 = path.getOrDefault("scriptExecutionId")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "scriptExecutionId", valid_568252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The HDInsight client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568253 = query.getOrDefault("api-version")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "api-version", valid_568253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568254: Call_ScriptActionsGetExecutionDetail_568246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the script execution detail for the given script execution ID.
  ## 
  let valid = call_568254.validator(path, query, header, formData, body)
  let scheme = call_568254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568254.url(scheme.get, call_568254.host, call_568254.base,
                         call_568254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568254, url, valid)

proc call*(call_568255: Call_ScriptActionsGetExecutionDetail_568246;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; scriptExecutionId: string): Recallable =
  ## scriptActionsGetExecutionDetail
  ## Gets the script execution detail for the given script execution ID.
  ##   clusterName: string (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The HDInsight client API Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   scriptExecutionId: string (required)
  ##                    : The script execution Id
  var path_568256 = newJObject()
  var query_568257 = newJObject()
  add(path_568256, "clusterName", newJString(clusterName))
  add(path_568256, "resourceGroupName", newJString(resourceGroupName))
  add(query_568257, "api-version", newJString(apiVersion))
  add(path_568256, "subscriptionId", newJString(subscriptionId))
  add(path_568256, "scriptExecutionId", newJString(scriptExecutionId))
  result = call_568255.call(path_568256, query_568257, nil, nil, nil)

var scriptActionsGetExecutionDetail* = Call_ScriptActionsGetExecutionDetail_568246(
    name: "scriptActionsGetExecutionDetail", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HDInsight/clusters/{clusterName}/scriptExecutionHistory/{scriptExecutionId}",
    validator: validate_ScriptActionsGetExecutionDetail_568247, base: "",
    url: url_ScriptActionsGetExecutionDetail_568248, schemes: {Scheme.Https})
type
  Call_ScriptExecutionHistoryPromote_568258 = ref object of OpenApiRestCall_567657
proc url_ScriptExecutionHistoryPromote_568260(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "scriptExecutionId" in path,
        "`scriptExecutionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.HDInsight/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/scriptExecutionHistory/"),
               (kind: VariableSegment, value: "scriptExecutionId"),
               (kind: ConstantSegment, value: "/promote")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptExecutionHistoryPromote_568259(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Promotes the specified ad-hoc script execution to a persisted script.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   scriptExecutionId: JString (required)
  ##                    : The script execution Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568261 = path.getOrDefault("clusterName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "clusterName", valid_568261
  var valid_568262 = path.getOrDefault("resourceGroupName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "resourceGroupName", valid_568262
  var valid_568263 = path.getOrDefault("subscriptionId")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "subscriptionId", valid_568263
  var valid_568264 = path.getOrDefault("scriptExecutionId")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "scriptExecutionId", valid_568264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The HDInsight client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568265 = query.getOrDefault("api-version")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "api-version", valid_568265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568266: Call_ScriptExecutionHistoryPromote_568258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Promotes the specified ad-hoc script execution to a persisted script.
  ## 
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_ScriptExecutionHistoryPromote_568258;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; scriptExecutionId: string): Recallable =
  ## scriptExecutionHistoryPromote
  ## Promotes the specified ad-hoc script execution to a persisted script.
  ##   clusterName: string (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The HDInsight client API Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   scriptExecutionId: string (required)
  ##                    : The script execution Id
  var path_568268 = newJObject()
  var query_568269 = newJObject()
  add(path_568268, "clusterName", newJString(clusterName))
  add(path_568268, "resourceGroupName", newJString(resourceGroupName))
  add(query_568269, "api-version", newJString(apiVersion))
  add(path_568268, "subscriptionId", newJString(subscriptionId))
  add(path_568268, "scriptExecutionId", newJString(scriptExecutionId))
  result = call_568267.call(path_568268, query_568269, nil, nil, nil)

var scriptExecutionHistoryPromote* = Call_ScriptExecutionHistoryPromote_568258(
    name: "scriptExecutionHistoryPromote", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HDInsight/clusters/{clusterName}/scriptExecutionHistory/{scriptExecutionId}/promote",
    validator: validate_ScriptExecutionHistoryPromote_568259, base: "",
    url: url_ScriptExecutionHistoryPromote_568260, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
