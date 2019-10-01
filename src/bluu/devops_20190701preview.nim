
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure DevOps
## version: 2019-07-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure DevOps Resource Provider
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

  OpenApiRestCall_567642 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567642](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567642): Option[Scheme] {.used.} =
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
  macServiceName = "devops"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567864 = ref object of OpenApiRestCall_567642
proc url_OperationsList_567866(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567865(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all the operations supported by Microsoft.DevOps resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568025 = query.getOrDefault("api-version")
  valid_568025 = validateParameter(valid_568025, JString, required = true,
                                 default = nil)
  if valid_568025 != nil:
    section.add "api-version", valid_568025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568048: Call_OperationsList_567864; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the operations supported by Microsoft.DevOps resource provider.
  ## 
  let valid = call_568048.validator(path, query, header, formData, body)
  let scheme = call_568048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568048.url(scheme.get, call_568048.host, call_568048.base,
                         call_568048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568048, url, valid)

proc call*(call_568119: Call_OperationsList_567864; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all the operations supported by Microsoft.DevOps resource provider.
  ##   apiVersion: string (required)
  ##             : API version to be used with the HTTP request.
  var query_568120 = newJObject()
  add(query_568120, "api-version", newJString(apiVersion))
  result = call_568119.call(nil, query_568120, nil, nil, nil)

var operationsList* = Call_OperationsList_567864(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DevOps/operations",
    validator: validate_OperationsList_567865, base: "", url: url_OperationsList_567866,
    schemes: {Scheme.Https})
type
  Call_PipelineTemplateDefinitionsList_568160 = ref object of OpenApiRestCall_567642
proc url_PipelineTemplateDefinitionsList_568162(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PipelineTemplateDefinitionsList_568161(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all pipeline templates which can be used to configure an Azure Pipeline.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568163 = query.getOrDefault("api-version")
  valid_568163 = validateParameter(valid_568163, JString, required = true,
                                 default = nil)
  if valid_568163 != nil:
    section.add "api-version", valid_568163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568164: Call_PipelineTemplateDefinitionsList_568160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all pipeline templates which can be used to configure an Azure Pipeline.
  ## 
  let valid = call_568164.validator(path, query, header, formData, body)
  let scheme = call_568164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568164.url(scheme.get, call_568164.host, call_568164.base,
                         call_568164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568164, url, valid)

proc call*(call_568165: Call_PipelineTemplateDefinitionsList_568160;
          apiVersion: string): Recallable =
  ## pipelineTemplateDefinitionsList
  ## Lists all pipeline templates which can be used to configure an Azure Pipeline.
  ##   apiVersion: string (required)
  ##             : API version to be used with the HTTP request.
  var query_568166 = newJObject()
  add(query_568166, "api-version", newJString(apiVersion))
  result = call_568165.call(nil, query_568166, nil, nil, nil)

var pipelineTemplateDefinitionsList* = Call_PipelineTemplateDefinitionsList_568160(
    name: "pipelineTemplateDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.DevOps/pipelineTemplateDefinitions",
    validator: validate_PipelineTemplateDefinitionsList_568161, base: "",
    url: url_PipelineTemplateDefinitionsList_568162, schemes: {Scheme.Https})
type
  Call_PipelinesListBySubscription_568167 = ref object of OpenApiRestCall_567642
proc url_PipelinesListBySubscription_568169(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevOps/pipelines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelinesListBySubscription_568168(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Azure Pipelines under the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Unique identifier of the Azure subscription. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568184 = path.getOrDefault("subscriptionId")
  valid_568184 = validateParameter(valid_568184, JString, required = true,
                                 default = nil)
  if valid_568184 != nil:
    section.add "subscriptionId", valid_568184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568185 = query.getOrDefault("api-version")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "api-version", valid_568185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568186: Call_PipelinesListBySubscription_568167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Azure Pipelines under the specified subscription.
  ## 
  let valid = call_568186.validator(path, query, header, formData, body)
  let scheme = call_568186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568186.url(scheme.get, call_568186.host, call_568186.base,
                         call_568186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568186, url, valid)

proc call*(call_568187: Call_PipelinesListBySubscription_568167;
          apiVersion: string; subscriptionId: string): Recallable =
  ## pipelinesListBySubscription
  ## Lists all Azure Pipelines under the specified subscription.
  ##   apiVersion: string (required)
  ##             : API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : Unique identifier of the Azure subscription. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568188 = newJObject()
  var query_568189 = newJObject()
  add(query_568189, "api-version", newJString(apiVersion))
  add(path_568188, "subscriptionId", newJString(subscriptionId))
  result = call_568187.call(path_568188, query_568189, nil, nil, nil)

var pipelinesListBySubscription* = Call_PipelinesListBySubscription_568167(
    name: "pipelinesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevOps/pipelines",
    validator: validate_PipelinesListBySubscription_568168, base: "",
    url: url_PipelinesListBySubscription_568169, schemes: {Scheme.Https})
type
  Call_PipelinesListByResourceGroup_568190 = ref object of OpenApiRestCall_567642
proc url_PipelinesListByResourceGroup_568192(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevOps/pipelines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelinesListByResourceGroup_568191(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Azure Pipelines under the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Unique identifier of the Azure subscription. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568193 = path.getOrDefault("resourceGroupName")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "resourceGroupName", valid_568193
  var valid_568194 = path.getOrDefault("subscriptionId")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "subscriptionId", valid_568194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568195 = query.getOrDefault("api-version")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "api-version", valid_568195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568196: Call_PipelinesListByResourceGroup_568190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Azure Pipelines under the specified resource group.
  ## 
  let valid = call_568196.validator(path, query, header, formData, body)
  let scheme = call_568196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568196.url(scheme.get, call_568196.host, call_568196.base,
                         call_568196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568196, url, valid)

proc call*(call_568197: Call_PipelinesListByResourceGroup_568190;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## pipelinesListByResourceGroup
  ## Lists all Azure Pipelines under the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : Unique identifier of the Azure subscription. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568198 = newJObject()
  var query_568199 = newJObject()
  add(path_568198, "resourceGroupName", newJString(resourceGroupName))
  add(query_568199, "api-version", newJString(apiVersion))
  add(path_568198, "subscriptionId", newJString(subscriptionId))
  result = call_568197.call(path_568198, query_568199, nil, nil, nil)

var pipelinesListByResourceGroup* = Call_PipelinesListByResourceGroup_568190(
    name: "pipelinesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevOps/pipelines",
    validator: validate_PipelinesListByResourceGroup_568191, base: "",
    url: url_PipelinesListByResourceGroup_568192, schemes: {Scheme.Https})
type
  Call_PipelinesCreateOrUpdate_568211 = ref object of OpenApiRestCall_567642
proc url_PipelinesCreateOrUpdate_568213(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "pipelineName" in path, "`pipelineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevOps/pipelines/"),
               (kind: VariableSegment, value: "pipelineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelinesCreateOrUpdate_568212(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an Azure Pipeline.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Unique identifier of the Azure subscription. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   pipelineName: JString (required)
  ##               : The name of the Azure Pipeline resource in ARM.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568214 = path.getOrDefault("resourceGroupName")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "resourceGroupName", valid_568214
  var valid_568215 = path.getOrDefault("subscriptionId")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "subscriptionId", valid_568215
  var valid_568216 = path.getOrDefault("pipelineName")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "pipelineName", valid_568216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568217 = query.getOrDefault("api-version")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "api-version", valid_568217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createOperationParameters: JObject (required)
  ##                            : The request payload to create the Azure Pipeline.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568219: Call_PipelinesCreateOrUpdate_568211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an Azure Pipeline.
  ## 
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_PipelinesCreateOrUpdate_568211;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          pipelineName: string; createOperationParameters: JsonNode): Recallable =
  ## pipelinesCreateOrUpdate
  ## Creates or updates an Azure Pipeline.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : Unique identifier of the Azure subscription. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   pipelineName: string (required)
  ##               : The name of the Azure Pipeline resource in ARM.
  ##   createOperationParameters: JObject (required)
  ##                            : The request payload to create the Azure Pipeline.
  var path_568221 = newJObject()
  var query_568222 = newJObject()
  var body_568223 = newJObject()
  add(path_568221, "resourceGroupName", newJString(resourceGroupName))
  add(query_568222, "api-version", newJString(apiVersion))
  add(path_568221, "subscriptionId", newJString(subscriptionId))
  add(path_568221, "pipelineName", newJString(pipelineName))
  if createOperationParameters != nil:
    body_568223 = createOperationParameters
  result = call_568220.call(path_568221, query_568222, nil, nil, body_568223)

var pipelinesCreateOrUpdate* = Call_PipelinesCreateOrUpdate_568211(
    name: "pipelinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevOps/pipelines/{pipelineName}",
    validator: validate_PipelinesCreateOrUpdate_568212, base: "",
    url: url_PipelinesCreateOrUpdate_568213, schemes: {Scheme.Https})
type
  Call_PipelinesGet_568200 = ref object of OpenApiRestCall_567642
proc url_PipelinesGet_568202(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "pipelineName" in path, "`pipelineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevOps/pipelines/"),
               (kind: VariableSegment, value: "pipelineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelinesGet_568201(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing Azure Pipeline.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Unique identifier of the Azure subscription. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   pipelineName: JString (required)
  ##               : The name of the Azure Pipeline resource in ARM.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568203 = path.getOrDefault("resourceGroupName")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "resourceGroupName", valid_568203
  var valid_568204 = path.getOrDefault("subscriptionId")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "subscriptionId", valid_568204
  var valid_568205 = path.getOrDefault("pipelineName")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "pipelineName", valid_568205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "api-version", valid_568206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568207: Call_PipelinesGet_568200; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing Azure Pipeline.
  ## 
  let valid = call_568207.validator(path, query, header, formData, body)
  let scheme = call_568207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568207.url(scheme.get, call_568207.host, call_568207.base,
                         call_568207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568207, url, valid)

proc call*(call_568208: Call_PipelinesGet_568200; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; pipelineName: string): Recallable =
  ## pipelinesGet
  ## Gets an existing Azure Pipeline.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : Unique identifier of the Azure subscription. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   pipelineName: string (required)
  ##               : The name of the Azure Pipeline resource in ARM.
  var path_568209 = newJObject()
  var query_568210 = newJObject()
  add(path_568209, "resourceGroupName", newJString(resourceGroupName))
  add(query_568210, "api-version", newJString(apiVersion))
  add(path_568209, "subscriptionId", newJString(subscriptionId))
  add(path_568209, "pipelineName", newJString(pipelineName))
  result = call_568208.call(path_568209, query_568210, nil, nil, nil)

var pipelinesGet* = Call_PipelinesGet_568200(name: "pipelinesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevOps/pipelines/{pipelineName}",
    validator: validate_PipelinesGet_568201, base: "", url: url_PipelinesGet_568202,
    schemes: {Scheme.Https})
type
  Call_PipelinesUpdate_568235 = ref object of OpenApiRestCall_567642
proc url_PipelinesUpdate_568237(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "pipelineName" in path, "`pipelineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevOps/pipelines/"),
               (kind: VariableSegment, value: "pipelineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelinesUpdate_568236(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates the properties of an Azure Pipeline. Currently, only tags can be updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Unique identifier of the Azure subscription. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   pipelineName: JString (required)
  ##               : The name of the Azure Pipeline resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568238 = path.getOrDefault("resourceGroupName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "resourceGroupName", valid_568238
  var valid_568239 = path.getOrDefault("subscriptionId")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "subscriptionId", valid_568239
  var valid_568240 = path.getOrDefault("pipelineName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "pipelineName", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to be used with the HTTP request.
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
  ## parameters in `body` object:
  ##   updateOperationParameters: JObject (required)
  ##                            : The request payload containing the properties to update in the Azure Pipeline.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568243: Call_PipelinesUpdate_568235; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an Azure Pipeline. Currently, only tags can be updated.
  ## 
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_PipelinesUpdate_568235; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; pipelineName: string;
          updateOperationParameters: JsonNode): Recallable =
  ## pipelinesUpdate
  ## Updates the properties of an Azure Pipeline. Currently, only tags can be updated.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : Unique identifier of the Azure subscription. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   pipelineName: string (required)
  ##               : The name of the Azure Pipeline resource.
  ##   updateOperationParameters: JObject (required)
  ##                            : The request payload containing the properties to update in the Azure Pipeline.
  var path_568245 = newJObject()
  var query_568246 = newJObject()
  var body_568247 = newJObject()
  add(path_568245, "resourceGroupName", newJString(resourceGroupName))
  add(query_568246, "api-version", newJString(apiVersion))
  add(path_568245, "subscriptionId", newJString(subscriptionId))
  add(path_568245, "pipelineName", newJString(pipelineName))
  if updateOperationParameters != nil:
    body_568247 = updateOperationParameters
  result = call_568244.call(path_568245, query_568246, nil, nil, body_568247)

var pipelinesUpdate* = Call_PipelinesUpdate_568235(name: "pipelinesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevOps/pipelines/{pipelineName}",
    validator: validate_PipelinesUpdate_568236, base: "", url: url_PipelinesUpdate_568237,
    schemes: {Scheme.Https})
type
  Call_PipelinesDelete_568224 = ref object of OpenApiRestCall_567642
proc url_PipelinesDelete_568226(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "pipelineName" in path, "`pipelineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevOps/pipelines/"),
               (kind: VariableSegment, value: "pipelineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelinesDelete_568225(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes an Azure Pipeline.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Unique identifier of the Azure subscription. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   pipelineName: JString (required)
  ##               : The name of the Azure Pipeline resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
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
  var valid_568229 = path.getOrDefault("pipelineName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "pipelineName", valid_568229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to be used with the HTTP request.
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

proc call*(call_568231: Call_PipelinesDelete_568224; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Pipeline.
  ## 
  let valid = call_568231.validator(path, query, header, formData, body)
  let scheme = call_568231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568231.url(scheme.get, call_568231.host, call_568231.base,
                         call_568231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568231, url, valid)

proc call*(call_568232: Call_PipelinesDelete_568224; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; pipelineName: string): Recallable =
  ## pipelinesDelete
  ## Deletes an Azure Pipeline.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : Unique identifier of the Azure subscription. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   pipelineName: string (required)
  ##               : The name of the Azure Pipeline resource.
  var path_568233 = newJObject()
  var query_568234 = newJObject()
  add(path_568233, "resourceGroupName", newJString(resourceGroupName))
  add(query_568234, "api-version", newJString(apiVersion))
  add(path_568233, "subscriptionId", newJString(subscriptionId))
  add(path_568233, "pipelineName", newJString(pipelineName))
  result = call_568232.call(path_568233, query_568234, nil, nil, nil)

var pipelinesDelete* = Call_PipelinesDelete_568224(name: "pipelinesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevOps/pipelines/{pipelineName}",
    validator: validate_PipelinesDelete_568225, base: "", url: url_PipelinesDelete_568226,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
