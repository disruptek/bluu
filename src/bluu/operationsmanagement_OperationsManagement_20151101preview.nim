
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Log Analytics - Operations Management
## version: 2015-11-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Log Analytics API reference for Solution.
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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "operationsmanagement-OperationsManagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567880 = ref object of OpenApiRestCall_567658
proc url_OperationsList_567882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567881(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available OperationsManagement Rest API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568041 = query.getOrDefault("api-version")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "api-version", valid_568041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568064: Call_OperationsList_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available OperationsManagement Rest API operations.
  ## 
  let valid = call_568064.validator(path, query, header, formData, body)
  let scheme = call_568064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568064.url(scheme.get, call_568064.host, call_568064.base,
                         call_568064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568064, url, valid)

proc call*(call_568135: Call_OperationsList_567880; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available OperationsManagement Rest API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  result = call_568135.call(nil, query_568136, nil, nil, nil)

var operationsList* = Call_OperationsList_567880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.OperationsManagement/operations",
    validator: validate_OperationsList_567881, base: "", url: url_OperationsList_567882,
    schemes: {Scheme.Https})
type
  Call_ManagementAssociationsListBySubscription_568176 = ref object of OpenApiRestCall_567658
proc url_ManagementAssociationsListBySubscription_568178(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.OperationsManagement/ManagementAssociations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementAssociationsListBySubscription_568177(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the ManagementAssociations list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568193 = path.getOrDefault("subscriptionId")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "subscriptionId", valid_568193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568194 = query.getOrDefault("api-version")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "api-version", valid_568194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568195: Call_ManagementAssociationsListBySubscription_568176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the ManagementAssociations list.
  ## 
  let valid = call_568195.validator(path, query, header, formData, body)
  let scheme = call_568195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568195.url(scheme.get, call_568195.host, call_568195.base,
                         call_568195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568195, url, valid)

proc call*(call_568196: Call_ManagementAssociationsListBySubscription_568176;
          apiVersion: string; subscriptionId: string): Recallable =
  ## managementAssociationsListBySubscription
  ## Retrieves the ManagementAssociations list.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568197 = newJObject()
  var query_568198 = newJObject()
  add(query_568198, "api-version", newJString(apiVersion))
  add(path_568197, "subscriptionId", newJString(subscriptionId))
  result = call_568196.call(path_568197, query_568198, nil, nil, nil)

var managementAssociationsListBySubscription* = Call_ManagementAssociationsListBySubscription_568176(
    name: "managementAssociationsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.OperationsManagement/ManagementAssociations",
    validator: validate_ManagementAssociationsListBySubscription_568177, base: "",
    url: url_ManagementAssociationsListBySubscription_568178,
    schemes: {Scheme.Https})
type
  Call_ManagementConfigurationsListBySubscription_568199 = ref object of OpenApiRestCall_567658
proc url_ManagementConfigurationsListBySubscription_568201(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.OperationsManagement/ManagementConfigurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementConfigurationsListBySubscription_568200(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the ManagementConfigurations list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568202 = path.getOrDefault("subscriptionId")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "subscriptionId", valid_568202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568203 = query.getOrDefault("api-version")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "api-version", valid_568203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568204: Call_ManagementConfigurationsListBySubscription_568199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the ManagementConfigurations list.
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_ManagementConfigurationsListBySubscription_568199;
          apiVersion: string; subscriptionId: string): Recallable =
  ## managementConfigurationsListBySubscription
  ## Retrieves the ManagementConfigurations list.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  add(query_568207, "api-version", newJString(apiVersion))
  add(path_568206, "subscriptionId", newJString(subscriptionId))
  result = call_568205.call(path_568206, query_568207, nil, nil, nil)

var managementConfigurationsListBySubscription* = Call_ManagementConfigurationsListBySubscription_568199(
    name: "managementConfigurationsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.OperationsManagement/ManagementConfigurations",
    validator: validate_ManagementConfigurationsListBySubscription_568200,
    base: "", url: url_ManagementConfigurationsListBySubscription_568201,
    schemes: {Scheme.Https})
type
  Call_SolutionsListBySubscription_568208 = ref object of OpenApiRestCall_567658
proc url_SolutionsListBySubscription_568210(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationsManagement/solutions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsListBySubscription_568209(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the solution list. It will retrieve both first party and third party solutions
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568211 = path.getOrDefault("subscriptionId")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "subscriptionId", valid_568211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568212 = query.getOrDefault("api-version")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "api-version", valid_568212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568213: Call_SolutionsListBySubscription_568208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the solution list. It will retrieve both first party and third party solutions
  ## 
  let valid = call_568213.validator(path, query, header, formData, body)
  let scheme = call_568213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568213.url(scheme.get, call_568213.host, call_568213.base,
                         call_568213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568213, url, valid)

proc call*(call_568214: Call_SolutionsListBySubscription_568208;
          apiVersion: string; subscriptionId: string): Recallable =
  ## solutionsListBySubscription
  ## Retrieves the solution list. It will retrieve both first party and third party solutions
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568215 = newJObject()
  var query_568216 = newJObject()
  add(query_568216, "api-version", newJString(apiVersion))
  add(path_568215, "subscriptionId", newJString(subscriptionId))
  result = call_568214.call(path_568215, query_568216, nil, nil, nil)

var solutionsListBySubscription* = Call_SolutionsListBySubscription_568208(
    name: "solutionsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.OperationsManagement/solutions",
    validator: validate_SolutionsListBySubscription_568209, base: "",
    url: url_SolutionsListBySubscription_568210, schemes: {Scheme.Https})
type
  Call_ManagementConfigurationsCreateOrUpdate_568228 = ref object of OpenApiRestCall_567658
proc url_ManagementConfigurationsCreateOrUpdate_568230(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managementConfigurationName" in path,
        "`managementConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.OperationsManagement/ManagementConfigurations/"),
               (kind: VariableSegment, value: "managementConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementConfigurationsCreateOrUpdate_568229(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the ManagementConfiguration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managementConfigurationName: JString (required)
  ##                              : User Management Configuration Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568248 = path.getOrDefault("resourceGroupName")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "resourceGroupName", valid_568248
  var valid_568249 = path.getOrDefault("subscriptionId")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "subscriptionId", valid_568249
  var valid_568250 = path.getOrDefault("managementConfigurationName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "managementConfigurationName", valid_568250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568251 = query.getOrDefault("api-version")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "api-version", valid_568251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters required to create OMS Solution.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568253: Call_ManagementConfigurationsCreateOrUpdate_568228;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the ManagementConfiguration.
  ## 
  let valid = call_568253.validator(path, query, header, formData, body)
  let scheme = call_568253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568253.url(scheme.get, call_568253.host, call_568253.base,
                         call_568253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568253, url, valid)

proc call*(call_568254: Call_ManagementConfigurationsCreateOrUpdate_568228;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          managementConfigurationName: string; parameters: JsonNode): Recallable =
  ## managementConfigurationsCreateOrUpdate
  ## Creates or updates the ManagementConfiguration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managementConfigurationName: string (required)
  ##                              : User Management Configuration Name.
  ##   parameters: JObject (required)
  ##             : The parameters required to create OMS Solution.
  var path_568255 = newJObject()
  var query_568256 = newJObject()
  var body_568257 = newJObject()
  add(path_568255, "resourceGroupName", newJString(resourceGroupName))
  add(query_568256, "api-version", newJString(apiVersion))
  add(path_568255, "subscriptionId", newJString(subscriptionId))
  add(path_568255, "managementConfigurationName",
      newJString(managementConfigurationName))
  if parameters != nil:
    body_568257 = parameters
  result = call_568254.call(path_568255, query_568256, nil, nil, body_568257)

var managementConfigurationsCreateOrUpdate* = Call_ManagementConfigurationsCreateOrUpdate_568228(
    name: "managementConfigurationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationsManagement/ManagementConfigurations/{managementConfigurationName}",
    validator: validate_ManagementConfigurationsCreateOrUpdate_568229, base: "",
    url: url_ManagementConfigurationsCreateOrUpdate_568230,
    schemes: {Scheme.Https})
type
  Call_ManagementConfigurationsGet_568217 = ref object of OpenApiRestCall_567658
proc url_ManagementConfigurationsGet_568219(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managementConfigurationName" in path,
        "`managementConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.OperationsManagement/ManagementConfigurations/"),
               (kind: VariableSegment, value: "managementConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementConfigurationsGet_568218(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the user ManagementConfiguration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managementConfigurationName: JString (required)
  ##                              : User Management Configuration Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568220 = path.getOrDefault("resourceGroupName")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "resourceGroupName", valid_568220
  var valid_568221 = path.getOrDefault("subscriptionId")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "subscriptionId", valid_568221
  var valid_568222 = path.getOrDefault("managementConfigurationName")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "managementConfigurationName", valid_568222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568223 = query.getOrDefault("api-version")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "api-version", valid_568223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568224: Call_ManagementConfigurationsGet_568217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the user ManagementConfiguration.
  ## 
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_ManagementConfigurationsGet_568217;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          managementConfigurationName: string): Recallable =
  ## managementConfigurationsGet
  ## Retrieves the user ManagementConfiguration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managementConfigurationName: string (required)
  ##                              : User Management Configuration Name.
  var path_568226 = newJObject()
  var query_568227 = newJObject()
  add(path_568226, "resourceGroupName", newJString(resourceGroupName))
  add(query_568227, "api-version", newJString(apiVersion))
  add(path_568226, "subscriptionId", newJString(subscriptionId))
  add(path_568226, "managementConfigurationName",
      newJString(managementConfigurationName))
  result = call_568225.call(path_568226, query_568227, nil, nil, nil)

var managementConfigurationsGet* = Call_ManagementConfigurationsGet_568217(
    name: "managementConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationsManagement/ManagementConfigurations/{managementConfigurationName}",
    validator: validate_ManagementConfigurationsGet_568218, base: "",
    url: url_ManagementConfigurationsGet_568219, schemes: {Scheme.Https})
type
  Call_ManagementConfigurationsDelete_568258 = ref object of OpenApiRestCall_567658
proc url_ManagementConfigurationsDelete_568260(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managementConfigurationName" in path,
        "`managementConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.OperationsManagement/ManagementConfigurations/"),
               (kind: VariableSegment, value: "managementConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementConfigurationsDelete_568259(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the ManagementConfiguration in the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managementConfigurationName: JString (required)
  ##                              : User Management Configuration Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568261 = path.getOrDefault("resourceGroupName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "resourceGroupName", valid_568261
  var valid_568262 = path.getOrDefault("subscriptionId")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "subscriptionId", valid_568262
  var valid_568263 = path.getOrDefault("managementConfigurationName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "managementConfigurationName", valid_568263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568264 = query.getOrDefault("api-version")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "api-version", valid_568264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568265: Call_ManagementConfigurationsDelete_568258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the ManagementConfiguration in the subscription.
  ## 
  let valid = call_568265.validator(path, query, header, formData, body)
  let scheme = call_568265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568265.url(scheme.get, call_568265.host, call_568265.base,
                         call_568265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568265, url, valid)

proc call*(call_568266: Call_ManagementConfigurationsDelete_568258;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          managementConfigurationName: string): Recallable =
  ## managementConfigurationsDelete
  ## Deletes the ManagementConfiguration in the subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managementConfigurationName: string (required)
  ##                              : User Management Configuration Name.
  var path_568267 = newJObject()
  var query_568268 = newJObject()
  add(path_568267, "resourceGroupName", newJString(resourceGroupName))
  add(query_568268, "api-version", newJString(apiVersion))
  add(path_568267, "subscriptionId", newJString(subscriptionId))
  add(path_568267, "managementConfigurationName",
      newJString(managementConfigurationName))
  result = call_568266.call(path_568267, query_568268, nil, nil, nil)

var managementConfigurationsDelete* = Call_ManagementConfigurationsDelete_568258(
    name: "managementConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationsManagement/ManagementConfigurations/{managementConfigurationName}",
    validator: validate_ManagementConfigurationsDelete_568259, base: "",
    url: url_ManagementConfigurationsDelete_568260, schemes: {Scheme.Https})
type
  Call_SolutionsListByResourceGroup_568269 = ref object of OpenApiRestCall_567658
proc url_SolutionsListByResourceGroup_568271(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationsManagement/solutions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsListByResourceGroup_568270(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the solution list. It will retrieve both first party and third party solutions
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568272 = path.getOrDefault("resourceGroupName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "resourceGroupName", valid_568272
  var valid_568273 = path.getOrDefault("subscriptionId")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "subscriptionId", valid_568273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568274 = query.getOrDefault("api-version")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "api-version", valid_568274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568275: Call_SolutionsListByResourceGroup_568269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the solution list. It will retrieve both first party and third party solutions
  ## 
  let valid = call_568275.validator(path, query, header, formData, body)
  let scheme = call_568275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568275.url(scheme.get, call_568275.host, call_568275.base,
                         call_568275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568275, url, valid)

proc call*(call_568276: Call_SolutionsListByResourceGroup_568269;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## solutionsListByResourceGroup
  ## Retrieves the solution list. It will retrieve both first party and third party solutions
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568277 = newJObject()
  var query_568278 = newJObject()
  add(path_568277, "resourceGroupName", newJString(resourceGroupName))
  add(query_568278, "api-version", newJString(apiVersion))
  add(path_568277, "subscriptionId", newJString(subscriptionId))
  result = call_568276.call(path_568277, query_568278, nil, nil, nil)

var solutionsListByResourceGroup* = Call_SolutionsListByResourceGroup_568269(
    name: "solutionsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationsManagement/solutions",
    validator: validate_SolutionsListByResourceGroup_568270, base: "",
    url: url_SolutionsListByResourceGroup_568271, schemes: {Scheme.Https})
type
  Call_SolutionsCreateOrUpdate_568290 = ref object of OpenApiRestCall_567658
proc url_SolutionsCreateOrUpdate_568292(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationsManagement/solutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsCreateOrUpdate_568291(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the Solution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : User Solution Name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568293 = path.getOrDefault("solutionName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "solutionName", valid_568293
  var valid_568294 = path.getOrDefault("resourceGroupName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "resourceGroupName", valid_568294
  var valid_568295 = path.getOrDefault("subscriptionId")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "subscriptionId", valid_568295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568296 = query.getOrDefault("api-version")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "api-version", valid_568296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters required to create OMS Solution.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568298: Call_SolutionsCreateOrUpdate_568290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the Solution.
  ## 
  let valid = call_568298.validator(path, query, header, formData, body)
  let scheme = call_568298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568298.url(scheme.get, call_568298.host, call_568298.base,
                         call_568298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568298, url, valid)

proc call*(call_568299: Call_SolutionsCreateOrUpdate_568290; solutionName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## solutionsCreateOrUpdate
  ## Creates or updates the Solution.
  ##   solutionName: string (required)
  ##               : User Solution Name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The parameters required to create OMS Solution.
  var path_568300 = newJObject()
  var query_568301 = newJObject()
  var body_568302 = newJObject()
  add(path_568300, "solutionName", newJString(solutionName))
  add(path_568300, "resourceGroupName", newJString(resourceGroupName))
  add(query_568301, "api-version", newJString(apiVersion))
  add(path_568300, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568302 = parameters
  result = call_568299.call(path_568300, query_568301, nil, nil, body_568302)

var solutionsCreateOrUpdate* = Call_SolutionsCreateOrUpdate_568290(
    name: "solutionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationsManagement/solutions/{solutionName}",
    validator: validate_SolutionsCreateOrUpdate_568291, base: "",
    url: url_SolutionsCreateOrUpdate_568292, schemes: {Scheme.Https})
type
  Call_SolutionsGet_568279 = ref object of OpenApiRestCall_567658
proc url_SolutionsGet_568281(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationsManagement/solutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsGet_568280(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the user solution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : User Solution Name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568282 = path.getOrDefault("solutionName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "solutionName", valid_568282
  var valid_568283 = path.getOrDefault("resourceGroupName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "resourceGroupName", valid_568283
  var valid_568284 = path.getOrDefault("subscriptionId")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "subscriptionId", valid_568284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568285 = query.getOrDefault("api-version")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "api-version", valid_568285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568286: Call_SolutionsGet_568279; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the user solution.
  ## 
  let valid = call_568286.validator(path, query, header, formData, body)
  let scheme = call_568286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568286.url(scheme.get, call_568286.host, call_568286.base,
                         call_568286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568286, url, valid)

proc call*(call_568287: Call_SolutionsGet_568279; solutionName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## solutionsGet
  ## Retrieves the user solution.
  ##   solutionName: string (required)
  ##               : User Solution Name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568288 = newJObject()
  var query_568289 = newJObject()
  add(path_568288, "solutionName", newJString(solutionName))
  add(path_568288, "resourceGroupName", newJString(resourceGroupName))
  add(query_568289, "api-version", newJString(apiVersion))
  add(path_568288, "subscriptionId", newJString(subscriptionId))
  result = call_568287.call(path_568288, query_568289, nil, nil, nil)

var solutionsGet* = Call_SolutionsGet_568279(name: "solutionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationsManagement/solutions/{solutionName}",
    validator: validate_SolutionsGet_568280, base: "", url: url_SolutionsGet_568281,
    schemes: {Scheme.Https})
type
  Call_SolutionsUpdate_568314 = ref object of OpenApiRestCall_567658
proc url_SolutionsUpdate_568316(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationsManagement/solutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsUpdate_568315(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Patch a Solution. Only updating tags supported.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : User Solution Name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568317 = path.getOrDefault("solutionName")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "solutionName", valid_568317
  var valid_568318 = path.getOrDefault("resourceGroupName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "resourceGroupName", valid_568318
  var valid_568319 = path.getOrDefault("subscriptionId")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "subscriptionId", valid_568319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568320 = query.getOrDefault("api-version")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "api-version", valid_568320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters required to patch a Solution.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568322: Call_SolutionsUpdate_568314; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a Solution. Only updating tags supported.
  ## 
  let valid = call_568322.validator(path, query, header, formData, body)
  let scheme = call_568322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568322.url(scheme.get, call_568322.host, call_568322.base,
                         call_568322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568322, url, valid)

proc call*(call_568323: Call_SolutionsUpdate_568314; solutionName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## solutionsUpdate
  ## Patch a Solution. Only updating tags supported.
  ##   solutionName: string (required)
  ##               : User Solution Name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The parameters required to patch a Solution.
  var path_568324 = newJObject()
  var query_568325 = newJObject()
  var body_568326 = newJObject()
  add(path_568324, "solutionName", newJString(solutionName))
  add(path_568324, "resourceGroupName", newJString(resourceGroupName))
  add(query_568325, "api-version", newJString(apiVersion))
  add(path_568324, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568326 = parameters
  result = call_568323.call(path_568324, query_568325, nil, nil, body_568326)

var solutionsUpdate* = Call_SolutionsUpdate_568314(name: "solutionsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationsManagement/solutions/{solutionName}",
    validator: validate_SolutionsUpdate_568315, base: "", url: url_SolutionsUpdate_568316,
    schemes: {Scheme.Https})
type
  Call_SolutionsDelete_568303 = ref object of OpenApiRestCall_567658
proc url_SolutionsDelete_568305(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationsManagement/solutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsDelete_568304(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes the solution in the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : User Solution Name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568306 = path.getOrDefault("solutionName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "solutionName", valid_568306
  var valid_568307 = path.getOrDefault("resourceGroupName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "resourceGroupName", valid_568307
  var valid_568308 = path.getOrDefault("subscriptionId")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "subscriptionId", valid_568308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568309 = query.getOrDefault("api-version")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "api-version", valid_568309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568310: Call_SolutionsDelete_568303; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the solution in the subscription.
  ## 
  let valid = call_568310.validator(path, query, header, formData, body)
  let scheme = call_568310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568310.url(scheme.get, call_568310.host, call_568310.base,
                         call_568310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568310, url, valid)

proc call*(call_568311: Call_SolutionsDelete_568303; solutionName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## solutionsDelete
  ## Deletes the solution in the subscription.
  ##   solutionName: string (required)
  ##               : User Solution Name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568312 = newJObject()
  var query_568313 = newJObject()
  add(path_568312, "solutionName", newJString(solutionName))
  add(path_568312, "resourceGroupName", newJString(resourceGroupName))
  add(query_568313, "api-version", newJString(apiVersion))
  add(path_568312, "subscriptionId", newJString(subscriptionId))
  result = call_568311.call(path_568312, query_568313, nil, nil, nil)

var solutionsDelete* = Call_SolutionsDelete_568303(name: "solutionsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationsManagement/solutions/{solutionName}",
    validator: validate_SolutionsDelete_568304, base: "", url: url_SolutionsDelete_568305,
    schemes: {Scheme.Https})
type
  Call_ManagementAssociationsCreateOrUpdate_568341 = ref object of OpenApiRestCall_567658
proc url_ManagementAssociationsCreateOrUpdate_568343(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "managementAssociationName" in path,
        "`managementAssociationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.OperationsManagement/ManagementAssociations/"),
               (kind: VariableSegment, value: "managementAssociationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementAssociationsCreateOrUpdate_568342(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the ManagementAssociation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource type for the parent resource
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Parent resource name.
  ##   managementAssociationName: JString (required)
  ##                            : User ManagementAssociation Name.
  ##   providerName: JString (required)
  ##               : Provider name for the parent resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568344 = path.getOrDefault("resourceType")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "resourceType", valid_568344
  var valid_568345 = path.getOrDefault("resourceGroupName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "resourceGroupName", valid_568345
  var valid_568346 = path.getOrDefault("subscriptionId")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "subscriptionId", valid_568346
  var valid_568347 = path.getOrDefault("resourceName")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "resourceName", valid_568347
  var valid_568348 = path.getOrDefault("managementAssociationName")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "managementAssociationName", valid_568348
  var valid_568349 = path.getOrDefault("providerName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "providerName", valid_568349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568350 = query.getOrDefault("api-version")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "api-version", valid_568350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters required to create ManagementAssociation extension.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568352: Call_ManagementAssociationsCreateOrUpdate_568341;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the ManagementAssociation.
  ## 
  let valid = call_568352.validator(path, query, header, formData, body)
  let scheme = call_568352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568352.url(scheme.get, call_568352.host, call_568352.base,
                         call_568352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568352, url, valid)

proc call*(call_568353: Call_ManagementAssociationsCreateOrUpdate_568341;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          managementAssociationName: string; providerName: string;
          parameters: JsonNode): Recallable =
  ## managementAssociationsCreateOrUpdate
  ## Creates or updates the ManagementAssociation.
  ##   resourceType: string (required)
  ##               : Resource type for the parent resource
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Parent resource name.
  ##   managementAssociationName: string (required)
  ##                            : User ManagementAssociation Name.
  ##   providerName: string (required)
  ##               : Provider name for the parent resource.
  ##   parameters: JObject (required)
  ##             : The parameters required to create ManagementAssociation extension.
  var path_568354 = newJObject()
  var query_568355 = newJObject()
  var body_568356 = newJObject()
  add(path_568354, "resourceType", newJString(resourceType))
  add(path_568354, "resourceGroupName", newJString(resourceGroupName))
  add(query_568355, "api-version", newJString(apiVersion))
  add(path_568354, "subscriptionId", newJString(subscriptionId))
  add(path_568354, "resourceName", newJString(resourceName))
  add(path_568354, "managementAssociationName",
      newJString(managementAssociationName))
  add(path_568354, "providerName", newJString(providerName))
  if parameters != nil:
    body_568356 = parameters
  result = call_568353.call(path_568354, query_568355, nil, nil, body_568356)

var managementAssociationsCreateOrUpdate* = Call_ManagementAssociationsCreateOrUpdate_568341(
    name: "managementAssociationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceName}/providers/Microsoft.OperationsManagement/ManagementAssociations/{managementAssociationName}",
    validator: validate_ManagementAssociationsCreateOrUpdate_568342, base: "",
    url: url_ManagementAssociationsCreateOrUpdate_568343, schemes: {Scheme.Https})
type
  Call_ManagementAssociationsGet_568327 = ref object of OpenApiRestCall_567658
proc url_ManagementAssociationsGet_568329(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "managementAssociationName" in path,
        "`managementAssociationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.OperationsManagement/ManagementAssociations/"),
               (kind: VariableSegment, value: "managementAssociationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementAssociationsGet_568328(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the user ManagementAssociation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource type for the parent resource
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Parent resource name.
  ##   managementAssociationName: JString (required)
  ##                            : User ManagementAssociation Name.
  ##   providerName: JString (required)
  ##               : Provider name for the parent resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568330 = path.getOrDefault("resourceType")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "resourceType", valid_568330
  var valid_568331 = path.getOrDefault("resourceGroupName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "resourceGroupName", valid_568331
  var valid_568332 = path.getOrDefault("subscriptionId")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "subscriptionId", valid_568332
  var valid_568333 = path.getOrDefault("resourceName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "resourceName", valid_568333
  var valid_568334 = path.getOrDefault("managementAssociationName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "managementAssociationName", valid_568334
  var valid_568335 = path.getOrDefault("providerName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "providerName", valid_568335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568336 = query.getOrDefault("api-version")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "api-version", valid_568336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568337: Call_ManagementAssociationsGet_568327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the user ManagementAssociation.
  ## 
  let valid = call_568337.validator(path, query, header, formData, body)
  let scheme = call_568337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568337.url(scheme.get, call_568337.host, call_568337.base,
                         call_568337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568337, url, valid)

proc call*(call_568338: Call_ManagementAssociationsGet_568327;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          managementAssociationName: string; providerName: string): Recallable =
  ## managementAssociationsGet
  ## Retrieves the user ManagementAssociation.
  ##   resourceType: string (required)
  ##               : Resource type for the parent resource
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Parent resource name.
  ##   managementAssociationName: string (required)
  ##                            : User ManagementAssociation Name.
  ##   providerName: string (required)
  ##               : Provider name for the parent resource.
  var path_568339 = newJObject()
  var query_568340 = newJObject()
  add(path_568339, "resourceType", newJString(resourceType))
  add(path_568339, "resourceGroupName", newJString(resourceGroupName))
  add(query_568340, "api-version", newJString(apiVersion))
  add(path_568339, "subscriptionId", newJString(subscriptionId))
  add(path_568339, "resourceName", newJString(resourceName))
  add(path_568339, "managementAssociationName",
      newJString(managementAssociationName))
  add(path_568339, "providerName", newJString(providerName))
  result = call_568338.call(path_568339, query_568340, nil, nil, nil)

var managementAssociationsGet* = Call_ManagementAssociationsGet_568327(
    name: "managementAssociationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceName}/providers/Microsoft.OperationsManagement/ManagementAssociations/{managementAssociationName}",
    validator: validate_ManagementAssociationsGet_568328, base: "",
    url: url_ManagementAssociationsGet_568329, schemes: {Scheme.Https})
type
  Call_ManagementAssociationsDelete_568357 = ref object of OpenApiRestCall_567658
proc url_ManagementAssociationsDelete_568359(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "managementAssociationName" in path,
        "`managementAssociationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.OperationsManagement/ManagementAssociations/"),
               (kind: VariableSegment, value: "managementAssociationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementAssociationsDelete_568358(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the ManagementAssociation in the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource type for the parent resource
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Parent resource name.
  ##   managementAssociationName: JString (required)
  ##                            : User ManagementAssociation Name.
  ##   providerName: JString (required)
  ##               : Provider name for the parent resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568360 = path.getOrDefault("resourceType")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "resourceType", valid_568360
  var valid_568361 = path.getOrDefault("resourceGroupName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "resourceGroupName", valid_568361
  var valid_568362 = path.getOrDefault("subscriptionId")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "subscriptionId", valid_568362
  var valid_568363 = path.getOrDefault("resourceName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "resourceName", valid_568363
  var valid_568364 = path.getOrDefault("managementAssociationName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "managementAssociationName", valid_568364
  var valid_568365 = path.getOrDefault("providerName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "providerName", valid_568365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568366 = query.getOrDefault("api-version")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "api-version", valid_568366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568367: Call_ManagementAssociationsDelete_568357; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the ManagementAssociation in the subscription.
  ## 
  let valid = call_568367.validator(path, query, header, formData, body)
  let scheme = call_568367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568367.url(scheme.get, call_568367.host, call_568367.base,
                         call_568367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568367, url, valid)

proc call*(call_568368: Call_ManagementAssociationsDelete_568357;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          managementAssociationName: string; providerName: string): Recallable =
  ## managementAssociationsDelete
  ## Deletes the ManagementAssociation in the subscription.
  ##   resourceType: string (required)
  ##               : Resource type for the parent resource
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Parent resource name.
  ##   managementAssociationName: string (required)
  ##                            : User ManagementAssociation Name.
  ##   providerName: string (required)
  ##               : Provider name for the parent resource.
  var path_568369 = newJObject()
  var query_568370 = newJObject()
  add(path_568369, "resourceType", newJString(resourceType))
  add(path_568369, "resourceGroupName", newJString(resourceGroupName))
  add(query_568370, "api-version", newJString(apiVersion))
  add(path_568369, "subscriptionId", newJString(subscriptionId))
  add(path_568369, "resourceName", newJString(resourceName))
  add(path_568369, "managementAssociationName",
      newJString(managementAssociationName))
  add(path_568369, "providerName", newJString(providerName))
  result = call_568368.call(path_568369, query_568370, nil, nil, nil)

var managementAssociationsDelete* = Call_ManagementAssociationsDelete_568357(
    name: "managementAssociationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceName}/providers/Microsoft.OperationsManagement/ManagementAssociations/{managementAssociationName}",
    validator: validate_ManagementAssociationsDelete_568358, base: "",
    url: url_ManagementAssociationsDelete_568359, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
