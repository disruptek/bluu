
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure SQL Database disaster recovery configurations
## version: 2014-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Provides create, read, update, delete, and failover functionality for Azure SQL Database disaster recovery configurations.
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
  macServiceName = "sql-disasterRecoveryConfigurations"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DisasterRecoveryConfigurationsList_567864 = ref object of OpenApiRestCall_567642
proc url_DisasterRecoveryConfigurationsList_567866(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfiguration")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigurationsList_567865(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a server's disaster recovery configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568039 = path.getOrDefault("resourceGroupName")
  valid_568039 = validateParameter(valid_568039, JString, required = true,
                                 default = nil)
  if valid_568039 != nil:
    section.add "resourceGroupName", valid_568039
  var valid_568040 = path.getOrDefault("serverName")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "serverName", valid_568040
  var valid_568041 = path.getOrDefault("subscriptionId")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "subscriptionId", valid_568041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568042 = query.getOrDefault("api-version")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "api-version", valid_568042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568065: Call_DisasterRecoveryConfigurationsList_567864;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a server's disaster recovery configuration.
  ## 
  let valid = call_568065.validator(path, query, header, formData, body)
  let scheme = call_568065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568065.url(scheme.get, call_568065.host, call_568065.base,
                         call_568065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568065, url, valid)

proc call*(call_568136: Call_DisasterRecoveryConfigurationsList_567864;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## disasterRecoveryConfigurationsList
  ## Lists a server's disaster recovery configuration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568137 = newJObject()
  var query_568139 = newJObject()
  add(path_568137, "resourceGroupName", newJString(resourceGroupName))
  add(query_568139, "api-version", newJString(apiVersion))
  add(path_568137, "serverName", newJString(serverName))
  add(path_568137, "subscriptionId", newJString(subscriptionId))
  result = call_568136.call(path_568137, query_568139, nil, nil, nil)

var disasterRecoveryConfigurationsList* = Call_DisasterRecoveryConfigurationsList_567864(
    name: "disasterRecoveryConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/disasterRecoveryConfiguration",
    validator: validate_DisasterRecoveryConfigurationsList_567865, base: "",
    url: url_DisasterRecoveryConfigurationsList_567866, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigurationsCreateOrUpdate_568190 = ref object of OpenApiRestCall_567642
proc url_DisasterRecoveryConfigurationsCreateOrUpdate_568192(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "disasterRecoveryConfigurationName" in path,
        "`disasterRecoveryConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"), (kind: ConstantSegment,
        value: "/disasterRecoveryConfiguration/"), (kind: VariableSegment,
        value: "disasterRecoveryConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigurationsCreateOrUpdate_568191(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a disaster recovery configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   disasterRecoveryConfigurationName: JString (required)
  ##                                    : The name of the disaster recovery configuration to be created/updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568193 = path.getOrDefault("resourceGroupName")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "resourceGroupName", valid_568193
  var valid_568194 = path.getOrDefault("serverName")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "serverName", valid_568194
  var valid_568195 = path.getOrDefault("subscriptionId")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "subscriptionId", valid_568195
  var valid_568196 = path.getOrDefault("disasterRecoveryConfigurationName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "disasterRecoveryConfigurationName", valid_568196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568197 = query.getOrDefault("api-version")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "api-version", valid_568197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568198: Call_DisasterRecoveryConfigurationsCreateOrUpdate_568190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a disaster recovery configuration.
  ## 
  let valid = call_568198.validator(path, query, header, formData, body)
  let scheme = call_568198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568198.url(scheme.get, call_568198.host, call_568198.base,
                         call_568198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568198, url, valid)

proc call*(call_568199: Call_DisasterRecoveryConfigurationsCreateOrUpdate_568190;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; disasterRecoveryConfigurationName: string): Recallable =
  ## disasterRecoveryConfigurationsCreateOrUpdate
  ## Creates or updates a disaster recovery configuration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   disasterRecoveryConfigurationName: string (required)
  ##                                    : The name of the disaster recovery configuration to be created/updated.
  var path_568200 = newJObject()
  var query_568201 = newJObject()
  add(path_568200, "resourceGroupName", newJString(resourceGroupName))
  add(query_568201, "api-version", newJString(apiVersion))
  add(path_568200, "serverName", newJString(serverName))
  add(path_568200, "subscriptionId", newJString(subscriptionId))
  add(path_568200, "disasterRecoveryConfigurationName",
      newJString(disasterRecoveryConfigurationName))
  result = call_568199.call(path_568200, query_568201, nil, nil, nil)

var disasterRecoveryConfigurationsCreateOrUpdate* = Call_DisasterRecoveryConfigurationsCreateOrUpdate_568190(
    name: "disasterRecoveryConfigurationsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/disasterRecoveryConfiguration/{disasterRecoveryConfigurationName}",
    validator: validate_DisasterRecoveryConfigurationsCreateOrUpdate_568191,
    base: "", url: url_DisasterRecoveryConfigurationsCreateOrUpdate_568192,
    schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigurationsGet_568178 = ref object of OpenApiRestCall_567642
proc url_DisasterRecoveryConfigurationsGet_568180(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "disasterRecoveryConfigurationName" in path,
        "`disasterRecoveryConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"), (kind: ConstantSegment,
        value: "/disasterRecoveryConfiguration/"), (kind: VariableSegment,
        value: "disasterRecoveryConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigurationsGet_568179(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a disaster recovery configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   disasterRecoveryConfigurationName: JString (required)
  ##                                    : The name of the disaster recovery configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568181 = path.getOrDefault("resourceGroupName")
  valid_568181 = validateParameter(valid_568181, JString, required = true,
                                 default = nil)
  if valid_568181 != nil:
    section.add "resourceGroupName", valid_568181
  var valid_568182 = path.getOrDefault("serverName")
  valid_568182 = validateParameter(valid_568182, JString, required = true,
                                 default = nil)
  if valid_568182 != nil:
    section.add "serverName", valid_568182
  var valid_568183 = path.getOrDefault("subscriptionId")
  valid_568183 = validateParameter(valid_568183, JString, required = true,
                                 default = nil)
  if valid_568183 != nil:
    section.add "subscriptionId", valid_568183
  var valid_568184 = path.getOrDefault("disasterRecoveryConfigurationName")
  valid_568184 = validateParameter(valid_568184, JString, required = true,
                                 default = nil)
  if valid_568184 != nil:
    section.add "disasterRecoveryConfigurationName", valid_568184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
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

proc call*(call_568186: Call_DisasterRecoveryConfigurationsGet_568178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a disaster recovery configuration.
  ## 
  let valid = call_568186.validator(path, query, header, formData, body)
  let scheme = call_568186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568186.url(scheme.get, call_568186.host, call_568186.base,
                         call_568186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568186, url, valid)

proc call*(call_568187: Call_DisasterRecoveryConfigurationsGet_568178;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; disasterRecoveryConfigurationName: string): Recallable =
  ## disasterRecoveryConfigurationsGet
  ## Gets a disaster recovery configuration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   disasterRecoveryConfigurationName: string (required)
  ##                                    : The name of the disaster recovery configuration.
  var path_568188 = newJObject()
  var query_568189 = newJObject()
  add(path_568188, "resourceGroupName", newJString(resourceGroupName))
  add(query_568189, "api-version", newJString(apiVersion))
  add(path_568188, "serverName", newJString(serverName))
  add(path_568188, "subscriptionId", newJString(subscriptionId))
  add(path_568188, "disasterRecoveryConfigurationName",
      newJString(disasterRecoveryConfigurationName))
  result = call_568187.call(path_568188, query_568189, nil, nil, nil)

var disasterRecoveryConfigurationsGet* = Call_DisasterRecoveryConfigurationsGet_568178(
    name: "disasterRecoveryConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/disasterRecoveryConfiguration/{disasterRecoveryConfigurationName}",
    validator: validate_DisasterRecoveryConfigurationsGet_568179, base: "",
    url: url_DisasterRecoveryConfigurationsGet_568180, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigurationsDelete_568202 = ref object of OpenApiRestCall_567642
proc url_DisasterRecoveryConfigurationsDelete_568204(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "disasterRecoveryConfigurationName" in path,
        "`disasterRecoveryConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"), (kind: ConstantSegment,
        value: "/disasterRecoveryConfiguration/"), (kind: VariableSegment,
        value: "disasterRecoveryConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigurationsDelete_568203(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a disaster recovery configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   disasterRecoveryConfigurationName: JString (required)
  ##                                    : The name of the disaster recovery configuration to be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568205 = path.getOrDefault("resourceGroupName")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "resourceGroupName", valid_568205
  var valid_568206 = path.getOrDefault("serverName")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "serverName", valid_568206
  var valid_568207 = path.getOrDefault("subscriptionId")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "subscriptionId", valid_568207
  var valid_568208 = path.getOrDefault("disasterRecoveryConfigurationName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "disasterRecoveryConfigurationName", valid_568208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568209 = query.getOrDefault("api-version")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "api-version", valid_568209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568210: Call_DisasterRecoveryConfigurationsDelete_568202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a disaster recovery configuration.
  ## 
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_DisasterRecoveryConfigurationsDelete_568202;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; disasterRecoveryConfigurationName: string): Recallable =
  ## disasterRecoveryConfigurationsDelete
  ## Deletes a disaster recovery configuration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   disasterRecoveryConfigurationName: string (required)
  ##                                    : The name of the disaster recovery configuration to be deleted.
  var path_568212 = newJObject()
  var query_568213 = newJObject()
  add(path_568212, "resourceGroupName", newJString(resourceGroupName))
  add(query_568213, "api-version", newJString(apiVersion))
  add(path_568212, "serverName", newJString(serverName))
  add(path_568212, "subscriptionId", newJString(subscriptionId))
  add(path_568212, "disasterRecoveryConfigurationName",
      newJString(disasterRecoveryConfigurationName))
  result = call_568211.call(path_568212, query_568213, nil, nil, nil)

var disasterRecoveryConfigurationsDelete* = Call_DisasterRecoveryConfigurationsDelete_568202(
    name: "disasterRecoveryConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/disasterRecoveryConfiguration/{disasterRecoveryConfigurationName}",
    validator: validate_DisasterRecoveryConfigurationsDelete_568203, base: "",
    url: url_DisasterRecoveryConfigurationsDelete_568204, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigurationsFailover_568214 = ref object of OpenApiRestCall_567642
proc url_DisasterRecoveryConfigurationsFailover_568216(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "disasterRecoveryConfigurationName" in path,
        "`disasterRecoveryConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"), (kind: ConstantSegment,
        value: "/disasterRecoveryConfiguration/"), (kind: VariableSegment,
        value: "disasterRecoveryConfigurationName"),
               (kind: ConstantSegment, value: "/failover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigurationsFailover_568215(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fails over from the current primary server to this server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   disasterRecoveryConfigurationName: JString (required)
  ##                                    : The name of the disaster recovery configuration to failover.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568217 = path.getOrDefault("resourceGroupName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "resourceGroupName", valid_568217
  var valid_568218 = path.getOrDefault("serverName")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "serverName", valid_568218
  var valid_568219 = path.getOrDefault("subscriptionId")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "subscriptionId", valid_568219
  var valid_568220 = path.getOrDefault("disasterRecoveryConfigurationName")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "disasterRecoveryConfigurationName", valid_568220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_DisasterRecoveryConfigurationsFailover_568214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fails over from the current primary server to this server.
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_DisasterRecoveryConfigurationsFailover_568214;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; disasterRecoveryConfigurationName: string): Recallable =
  ## disasterRecoveryConfigurationsFailover
  ## Fails over from the current primary server to this server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   disasterRecoveryConfigurationName: string (required)
  ##                                    : The name of the disaster recovery configuration to failover.
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  add(path_568224, "resourceGroupName", newJString(resourceGroupName))
  add(query_568225, "api-version", newJString(apiVersion))
  add(path_568224, "serverName", newJString(serverName))
  add(path_568224, "subscriptionId", newJString(subscriptionId))
  add(path_568224, "disasterRecoveryConfigurationName",
      newJString(disasterRecoveryConfigurationName))
  result = call_568223.call(path_568224, query_568225, nil, nil, nil)

var disasterRecoveryConfigurationsFailover* = Call_DisasterRecoveryConfigurationsFailover_568214(
    name: "disasterRecoveryConfigurationsFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/disasterRecoveryConfiguration/{disasterRecoveryConfigurationName}/failover",
    validator: validate_DisasterRecoveryConfigurationsFailover_568215, base: "",
    url: url_DisasterRecoveryConfigurationsFailover_568216,
    schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigurationsFailoverAllowDataLoss_568226 = ref object of OpenApiRestCall_567642
proc url_DisasterRecoveryConfigurationsFailoverAllowDataLoss_568228(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "disasterRecoveryConfigurationName" in path,
        "`disasterRecoveryConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"), (kind: ConstantSegment,
        value: "/disasterRecoveryConfiguration/"), (kind: VariableSegment,
        value: "disasterRecoveryConfigurationName"),
               (kind: ConstantSegment, value: "/forceFailoverAllowDataLoss")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigurationsFailoverAllowDataLoss_568227(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Fails over from the current primary server to this server. This operation might result in data loss.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   disasterRecoveryConfigurationName: JString (required)
  ##                                    : The name of the disaster recovery configuration to failover forcefully.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568229 = path.getOrDefault("resourceGroupName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "resourceGroupName", valid_568229
  var valid_568230 = path.getOrDefault("serverName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "serverName", valid_568230
  var valid_568231 = path.getOrDefault("subscriptionId")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "subscriptionId", valid_568231
  var valid_568232 = path.getOrDefault("disasterRecoveryConfigurationName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "disasterRecoveryConfigurationName", valid_568232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568233 = query.getOrDefault("api-version")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "api-version", valid_568233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568234: Call_DisasterRecoveryConfigurationsFailoverAllowDataLoss_568226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fails over from the current primary server to this server. This operation might result in data loss.
  ## 
  let valid = call_568234.validator(path, query, header, formData, body)
  let scheme = call_568234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568234.url(scheme.get, call_568234.host, call_568234.base,
                         call_568234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568234, url, valid)

proc call*(call_568235: Call_DisasterRecoveryConfigurationsFailoverAllowDataLoss_568226;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; disasterRecoveryConfigurationName: string): Recallable =
  ## disasterRecoveryConfigurationsFailoverAllowDataLoss
  ## Fails over from the current primary server to this server. This operation might result in data loss.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   disasterRecoveryConfigurationName: string (required)
  ##                                    : The name of the disaster recovery configuration to failover forcefully.
  var path_568236 = newJObject()
  var query_568237 = newJObject()
  add(path_568236, "resourceGroupName", newJString(resourceGroupName))
  add(query_568237, "api-version", newJString(apiVersion))
  add(path_568236, "serverName", newJString(serverName))
  add(path_568236, "subscriptionId", newJString(subscriptionId))
  add(path_568236, "disasterRecoveryConfigurationName",
      newJString(disasterRecoveryConfigurationName))
  result = call_568235.call(path_568236, query_568237, nil, nil, nil)

var disasterRecoveryConfigurationsFailoverAllowDataLoss* = Call_DisasterRecoveryConfigurationsFailoverAllowDataLoss_568226(
    name: "disasterRecoveryConfigurationsFailoverAllowDataLoss",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/disasterRecoveryConfiguration/{disasterRecoveryConfigurationName}/forceFailoverAllowDataLoss",
    validator: validate_DisasterRecoveryConfigurationsFailoverAllowDataLoss_568227,
    base: "", url: url_DisasterRecoveryConfigurationsFailoverAllowDataLoss_568228,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
