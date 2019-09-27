
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593409 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593409](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593409): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_OperationsList_593631 = ref object of OpenApiRestCall_593409
proc url_OperationsList_593633(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593632(path: JsonNode; query: JsonNode;
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
  var valid_593792 = query.getOrDefault("api-version")
  valid_593792 = validateParameter(valid_593792, JString, required = true,
                                 default = nil)
  if valid_593792 != nil:
    section.add "api-version", valid_593792
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593815: Call_OperationsList_593631; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the operations supported by Microsoft.DevOps resource provider.
  ## 
  let valid = call_593815.validator(path, query, header, formData, body)
  let scheme = call_593815.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593815.url(scheme.get, call_593815.host, call_593815.base,
                         call_593815.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593815, url, valid)

proc call*(call_593886: Call_OperationsList_593631; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all the operations supported by Microsoft.DevOps resource provider.
  ##   apiVersion: string (required)
  ##             : API version to be used with the HTTP request.
  var query_593887 = newJObject()
  add(query_593887, "api-version", newJString(apiVersion))
  result = call_593886.call(nil, query_593887, nil, nil, nil)

var operationsList* = Call_OperationsList_593631(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DevOps/operations",
    validator: validate_OperationsList_593632, base: "", url: url_OperationsList_593633,
    schemes: {Scheme.Https})
type
  Call_PipelineTemplateDefinitionsList_593927 = ref object of OpenApiRestCall_593409
proc url_PipelineTemplateDefinitionsList_593929(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PipelineTemplateDefinitionsList_593928(path: JsonNode;
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
  var valid_593930 = query.getOrDefault("api-version")
  valid_593930 = validateParameter(valid_593930, JString, required = true,
                                 default = nil)
  if valid_593930 != nil:
    section.add "api-version", valid_593930
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593931: Call_PipelineTemplateDefinitionsList_593927;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all pipeline templates which can be used to configure an Azure Pipeline.
  ## 
  let valid = call_593931.validator(path, query, header, formData, body)
  let scheme = call_593931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593931.url(scheme.get, call_593931.host, call_593931.base,
                         call_593931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593931, url, valid)

proc call*(call_593932: Call_PipelineTemplateDefinitionsList_593927;
          apiVersion: string): Recallable =
  ## pipelineTemplateDefinitionsList
  ## Lists all pipeline templates which can be used to configure an Azure Pipeline.
  ##   apiVersion: string (required)
  ##             : API version to be used with the HTTP request.
  var query_593933 = newJObject()
  add(query_593933, "api-version", newJString(apiVersion))
  result = call_593932.call(nil, query_593933, nil, nil, nil)

var pipelineTemplateDefinitionsList* = Call_PipelineTemplateDefinitionsList_593927(
    name: "pipelineTemplateDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.DevOps/pipelineTemplateDefinitions",
    validator: validate_PipelineTemplateDefinitionsList_593928, base: "",
    url: url_PipelineTemplateDefinitionsList_593929, schemes: {Scheme.Https})
type
  Call_PipelinesListBySubscription_593934 = ref object of OpenApiRestCall_593409
proc url_PipelinesListBySubscription_593936(protocol: Scheme; host: string;
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

proc validate_PipelinesListBySubscription_593935(path: JsonNode; query: JsonNode;
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
  var valid_593951 = path.getOrDefault("subscriptionId")
  valid_593951 = validateParameter(valid_593951, JString, required = true,
                                 default = nil)
  if valid_593951 != nil:
    section.add "subscriptionId", valid_593951
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593952 = query.getOrDefault("api-version")
  valid_593952 = validateParameter(valid_593952, JString, required = true,
                                 default = nil)
  if valid_593952 != nil:
    section.add "api-version", valid_593952
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593953: Call_PipelinesListBySubscription_593934; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Azure Pipelines under the specified subscription.
  ## 
  let valid = call_593953.validator(path, query, header, formData, body)
  let scheme = call_593953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593953.url(scheme.get, call_593953.host, call_593953.base,
                         call_593953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593953, url, valid)

proc call*(call_593954: Call_PipelinesListBySubscription_593934;
          apiVersion: string; subscriptionId: string): Recallable =
  ## pipelinesListBySubscription
  ## Lists all Azure Pipelines under the specified subscription.
  ##   apiVersion: string (required)
  ##             : API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : Unique identifier of the Azure subscription. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_593955 = newJObject()
  var query_593956 = newJObject()
  add(query_593956, "api-version", newJString(apiVersion))
  add(path_593955, "subscriptionId", newJString(subscriptionId))
  result = call_593954.call(path_593955, query_593956, nil, nil, nil)

var pipelinesListBySubscription* = Call_PipelinesListBySubscription_593934(
    name: "pipelinesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevOps/pipelines",
    validator: validate_PipelinesListBySubscription_593935, base: "",
    url: url_PipelinesListBySubscription_593936, schemes: {Scheme.Https})
type
  Call_PipelinesListByResourceGroup_593957 = ref object of OpenApiRestCall_593409
proc url_PipelinesListByResourceGroup_593959(protocol: Scheme; host: string;
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

proc validate_PipelinesListByResourceGroup_593958(path: JsonNode; query: JsonNode;
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
  var valid_593960 = path.getOrDefault("resourceGroupName")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "resourceGroupName", valid_593960
  var valid_593961 = path.getOrDefault("subscriptionId")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "subscriptionId", valid_593961
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593962 = query.getOrDefault("api-version")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "api-version", valid_593962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593963: Call_PipelinesListByResourceGroup_593957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Azure Pipelines under the specified resource group.
  ## 
  let valid = call_593963.validator(path, query, header, formData, body)
  let scheme = call_593963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593963.url(scheme.get, call_593963.host, call_593963.base,
                         call_593963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593963, url, valid)

proc call*(call_593964: Call_PipelinesListByResourceGroup_593957;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## pipelinesListByResourceGroup
  ## Lists all Azure Pipelines under the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : Unique identifier of the Azure subscription. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_593965 = newJObject()
  var query_593966 = newJObject()
  add(path_593965, "resourceGroupName", newJString(resourceGroupName))
  add(query_593966, "api-version", newJString(apiVersion))
  add(path_593965, "subscriptionId", newJString(subscriptionId))
  result = call_593964.call(path_593965, query_593966, nil, nil, nil)

var pipelinesListByResourceGroup* = Call_PipelinesListByResourceGroup_593957(
    name: "pipelinesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevOps/pipelines",
    validator: validate_PipelinesListByResourceGroup_593958, base: "",
    url: url_PipelinesListByResourceGroup_593959, schemes: {Scheme.Https})
type
  Call_PipelinesCreateOrUpdate_593978 = ref object of OpenApiRestCall_593409
proc url_PipelinesCreateOrUpdate_593980(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesCreateOrUpdate_593979(path: JsonNode; query: JsonNode;
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
  var valid_593981 = path.getOrDefault("resourceGroupName")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "resourceGroupName", valid_593981
  var valid_593982 = path.getOrDefault("subscriptionId")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "subscriptionId", valid_593982
  var valid_593983 = path.getOrDefault("pipelineName")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "pipelineName", valid_593983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593984 = query.getOrDefault("api-version")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "api-version", valid_593984
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

proc call*(call_593986: Call_PipelinesCreateOrUpdate_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an Azure Pipeline.
  ## 
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_PipelinesCreateOrUpdate_593978;
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
  var path_593988 = newJObject()
  var query_593989 = newJObject()
  var body_593990 = newJObject()
  add(path_593988, "resourceGroupName", newJString(resourceGroupName))
  add(query_593989, "api-version", newJString(apiVersion))
  add(path_593988, "subscriptionId", newJString(subscriptionId))
  add(path_593988, "pipelineName", newJString(pipelineName))
  if createOperationParameters != nil:
    body_593990 = createOperationParameters
  result = call_593987.call(path_593988, query_593989, nil, nil, body_593990)

var pipelinesCreateOrUpdate* = Call_PipelinesCreateOrUpdate_593978(
    name: "pipelinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevOps/pipelines/{pipelineName}",
    validator: validate_PipelinesCreateOrUpdate_593979, base: "",
    url: url_PipelinesCreateOrUpdate_593980, schemes: {Scheme.Https})
type
  Call_PipelinesGet_593967 = ref object of OpenApiRestCall_593409
proc url_PipelinesGet_593969(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesGet_593968(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593970 = path.getOrDefault("resourceGroupName")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "resourceGroupName", valid_593970
  var valid_593971 = path.getOrDefault("subscriptionId")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "subscriptionId", valid_593971
  var valid_593972 = path.getOrDefault("pipelineName")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "pipelineName", valid_593972
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593973 = query.getOrDefault("api-version")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "api-version", valid_593973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593974: Call_PipelinesGet_593967; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing Azure Pipeline.
  ## 
  let valid = call_593974.validator(path, query, header, formData, body)
  let scheme = call_593974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593974.url(scheme.get, call_593974.host, call_593974.base,
                         call_593974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593974, url, valid)

proc call*(call_593975: Call_PipelinesGet_593967; resourceGroupName: string;
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
  var path_593976 = newJObject()
  var query_593977 = newJObject()
  add(path_593976, "resourceGroupName", newJString(resourceGroupName))
  add(query_593977, "api-version", newJString(apiVersion))
  add(path_593976, "subscriptionId", newJString(subscriptionId))
  add(path_593976, "pipelineName", newJString(pipelineName))
  result = call_593975.call(path_593976, query_593977, nil, nil, nil)

var pipelinesGet* = Call_PipelinesGet_593967(name: "pipelinesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevOps/pipelines/{pipelineName}",
    validator: validate_PipelinesGet_593968, base: "", url: url_PipelinesGet_593969,
    schemes: {Scheme.Https})
type
  Call_PipelinesUpdate_594002 = ref object of OpenApiRestCall_593409
proc url_PipelinesUpdate_594004(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesUpdate_594003(path: JsonNode; query: JsonNode;
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
  var valid_594005 = path.getOrDefault("resourceGroupName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "resourceGroupName", valid_594005
  var valid_594006 = path.getOrDefault("subscriptionId")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "subscriptionId", valid_594006
  var valid_594007 = path.getOrDefault("pipelineName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "pipelineName", valid_594007
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594008 = query.getOrDefault("api-version")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "api-version", valid_594008
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

proc call*(call_594010: Call_PipelinesUpdate_594002; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an Azure Pipeline. Currently, only tags can be updated.
  ## 
  let valid = call_594010.validator(path, query, header, formData, body)
  let scheme = call_594010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594010.url(scheme.get, call_594010.host, call_594010.base,
                         call_594010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594010, url, valid)

proc call*(call_594011: Call_PipelinesUpdate_594002; resourceGroupName: string;
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
  var path_594012 = newJObject()
  var query_594013 = newJObject()
  var body_594014 = newJObject()
  add(path_594012, "resourceGroupName", newJString(resourceGroupName))
  add(query_594013, "api-version", newJString(apiVersion))
  add(path_594012, "subscriptionId", newJString(subscriptionId))
  add(path_594012, "pipelineName", newJString(pipelineName))
  if updateOperationParameters != nil:
    body_594014 = updateOperationParameters
  result = call_594011.call(path_594012, query_594013, nil, nil, body_594014)

var pipelinesUpdate* = Call_PipelinesUpdate_594002(name: "pipelinesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevOps/pipelines/{pipelineName}",
    validator: validate_PipelinesUpdate_594003, base: "", url: url_PipelinesUpdate_594004,
    schemes: {Scheme.Https})
type
  Call_PipelinesDelete_593991 = ref object of OpenApiRestCall_593409
proc url_PipelinesDelete_593993(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesDelete_593992(path: JsonNode; query: JsonNode;
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
  var valid_593994 = path.getOrDefault("resourceGroupName")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "resourceGroupName", valid_593994
  var valid_593995 = path.getOrDefault("subscriptionId")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "subscriptionId", valid_593995
  var valid_593996 = path.getOrDefault("pipelineName")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "pipelineName", valid_593996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593997 = query.getOrDefault("api-version")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "api-version", valid_593997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593998: Call_PipelinesDelete_593991; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Pipeline.
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_PipelinesDelete_593991; resourceGroupName: string;
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
  var path_594000 = newJObject()
  var query_594001 = newJObject()
  add(path_594000, "resourceGroupName", newJString(resourceGroupName))
  add(query_594001, "api-version", newJString(apiVersion))
  add(path_594000, "subscriptionId", newJString(subscriptionId))
  add(path_594000, "pipelineName", newJString(pipelineName))
  result = call_593999.call(path_594000, query_594001, nil, nil, nil)

var pipelinesDelete* = Call_PipelinesDelete_593991(name: "pipelinesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevOps/pipelines/{pipelineName}",
    validator: validate_PipelinesDelete_593992, base: "", url: url_PipelinesDelete_593993,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
