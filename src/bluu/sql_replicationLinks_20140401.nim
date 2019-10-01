
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure SQL Database replication links
## version: 2014-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Provides read, delete, and failover functionality for Azure SQL Database replication links.
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
  macServiceName = "sql-replicationLinks"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ReplicationLinksListByDatabase_567880 = ref object of OpenApiRestCall_567658
proc url_ReplicationLinksListByDatabase_567882(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/replicationLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationLinksListByDatabase_567881(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a database's replication links.
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
  ##   databaseName: JString (required)
  ##               : The name of the database to retrieve links for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568055 = path.getOrDefault("resourceGroupName")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "resourceGroupName", valid_568055
  var valid_568056 = path.getOrDefault("serverName")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "serverName", valid_568056
  var valid_568057 = path.getOrDefault("subscriptionId")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "subscriptionId", valid_568057
  var valid_568058 = path.getOrDefault("databaseName")
  valid_568058 = validateParameter(valid_568058, JString, required = true,
                                 default = nil)
  if valid_568058 != nil:
    section.add "databaseName", valid_568058
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568059 = query.getOrDefault("api-version")
  valid_568059 = validateParameter(valid_568059, JString, required = true,
                                 default = nil)
  if valid_568059 != nil:
    section.add "api-version", valid_568059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568082: Call_ReplicationLinksListByDatabase_567880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a database's replication links.
  ## 
  let valid = call_568082.validator(path, query, header, formData, body)
  let scheme = call_568082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568082.url(scheme.get, call_568082.host, call_568082.base,
                         call_568082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568082, url, valid)

proc call*(call_568153: Call_ReplicationLinksListByDatabase_567880;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string): Recallable =
  ## replicationLinksListByDatabase
  ## Lists a database's replication links.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database to retrieve links for.
  var path_568154 = newJObject()
  var query_568156 = newJObject()
  add(path_568154, "resourceGroupName", newJString(resourceGroupName))
  add(query_568156, "api-version", newJString(apiVersion))
  add(path_568154, "serverName", newJString(serverName))
  add(path_568154, "subscriptionId", newJString(subscriptionId))
  add(path_568154, "databaseName", newJString(databaseName))
  result = call_568153.call(path_568154, query_568156, nil, nil, nil)

var replicationLinksListByDatabase* = Call_ReplicationLinksListByDatabase_567880(
    name: "replicationLinksListByDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/replicationLinks",
    validator: validate_ReplicationLinksListByDatabase_567881, base: "",
    url: url_ReplicationLinksListByDatabase_567882, schemes: {Scheme.Https})
type
  Call_ReplicationLinksGet_568195 = ref object of OpenApiRestCall_567658
proc url_ReplicationLinksGet_568197(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/replicationLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationLinksGet_568196(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets a database replication link.
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
  ##   databaseName: JString (required)
  ##               : The name of the database to get the link for.
  ##   linkId: JString (required)
  ##         : The replication link ID to be retrieved.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568198 = path.getOrDefault("resourceGroupName")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "resourceGroupName", valid_568198
  var valid_568199 = path.getOrDefault("serverName")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "serverName", valid_568199
  var valid_568200 = path.getOrDefault("subscriptionId")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "subscriptionId", valid_568200
  var valid_568201 = path.getOrDefault("databaseName")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "databaseName", valid_568201
  var valid_568202 = path.getOrDefault("linkId")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "linkId", valid_568202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
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

proc call*(call_568204: Call_ReplicationLinksGet_568195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a database replication link.
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_ReplicationLinksGet_568195; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string; linkId: string): Recallable =
  ## replicationLinksGet
  ## Gets a database replication link.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database to get the link for.
  ##   linkId: string (required)
  ##         : The replication link ID to be retrieved.
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  add(path_568206, "resourceGroupName", newJString(resourceGroupName))
  add(query_568207, "api-version", newJString(apiVersion))
  add(path_568206, "serverName", newJString(serverName))
  add(path_568206, "subscriptionId", newJString(subscriptionId))
  add(path_568206, "databaseName", newJString(databaseName))
  add(path_568206, "linkId", newJString(linkId))
  result = call_568205.call(path_568206, query_568207, nil, nil, nil)

var replicationLinksGet* = Call_ReplicationLinksGet_568195(
    name: "replicationLinksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/replicationLinks/{linkId}",
    validator: validate_ReplicationLinksGet_568196, base: "",
    url: url_ReplicationLinksGet_568197, schemes: {Scheme.Https})
type
  Call_ReplicationLinksDelete_568208 = ref object of OpenApiRestCall_567658
proc url_ReplicationLinksDelete_568210(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/replicationLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationLinksDelete_568209(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a database replication link. Cannot be done during failover.
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
  ##   databaseName: JString (required)
  ##               : The name of the database that has the replication link to be dropped.
  ##   linkId: JString (required)
  ##         : The ID of the replication link to be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568211 = path.getOrDefault("resourceGroupName")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "resourceGroupName", valid_568211
  var valid_568212 = path.getOrDefault("serverName")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "serverName", valid_568212
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
  var valid_568214 = path.getOrDefault("databaseName")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "databaseName", valid_568214
  var valid_568215 = path.getOrDefault("linkId")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "linkId", valid_568215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568216 = query.getOrDefault("api-version")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "api-version", valid_568216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568217: Call_ReplicationLinksDelete_568208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a database replication link. Cannot be done during failover.
  ## 
  let valid = call_568217.validator(path, query, header, formData, body)
  let scheme = call_568217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568217.url(scheme.get, call_568217.host, call_568217.base,
                         call_568217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568217, url, valid)

proc call*(call_568218: Call_ReplicationLinksDelete_568208;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string; linkId: string): Recallable =
  ## replicationLinksDelete
  ## Deletes a database replication link. Cannot be done during failover.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database that has the replication link to be dropped.
  ##   linkId: string (required)
  ##         : The ID of the replication link to be deleted.
  var path_568219 = newJObject()
  var query_568220 = newJObject()
  add(path_568219, "resourceGroupName", newJString(resourceGroupName))
  add(query_568220, "api-version", newJString(apiVersion))
  add(path_568219, "serverName", newJString(serverName))
  add(path_568219, "subscriptionId", newJString(subscriptionId))
  add(path_568219, "databaseName", newJString(databaseName))
  add(path_568219, "linkId", newJString(linkId))
  result = call_568218.call(path_568219, query_568220, nil, nil, nil)

var replicationLinksDelete* = Call_ReplicationLinksDelete_568208(
    name: "replicationLinksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/replicationLinks/{linkId}",
    validator: validate_ReplicationLinksDelete_568209, base: "",
    url: url_ReplicationLinksDelete_568210, schemes: {Scheme.Https})
type
  Call_ReplicationLinksFailover_568221 = ref object of OpenApiRestCall_567658
proc url_ReplicationLinksFailover_568223(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/replicationLinks/"),
               (kind: VariableSegment, value: "linkId"),
               (kind: ConstantSegment, value: "/failover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationLinksFailover_568222(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets which replica database is primary by failing over from the current primary replica database.
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
  ##   databaseName: JString (required)
  ##               : The name of the database that has the replication link to be failed over.
  ##   linkId: JString (required)
  ##         : The ID of the replication link to be failed over.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568224 = path.getOrDefault("resourceGroupName")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "resourceGroupName", valid_568224
  var valid_568225 = path.getOrDefault("serverName")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "serverName", valid_568225
  var valid_568226 = path.getOrDefault("subscriptionId")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "subscriptionId", valid_568226
  var valid_568227 = path.getOrDefault("databaseName")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "databaseName", valid_568227
  var valid_568228 = path.getOrDefault("linkId")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "linkId", valid_568228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568229 = query.getOrDefault("api-version")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "api-version", valid_568229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568230: Call_ReplicationLinksFailover_568221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets which replica database is primary by failing over from the current primary replica database.
  ## 
  let valid = call_568230.validator(path, query, header, formData, body)
  let scheme = call_568230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568230.url(scheme.get, call_568230.host, call_568230.base,
                         call_568230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568230, url, valid)

proc call*(call_568231: Call_ReplicationLinksFailover_568221;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string; linkId: string): Recallable =
  ## replicationLinksFailover
  ## Sets which replica database is primary by failing over from the current primary replica database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database that has the replication link to be failed over.
  ##   linkId: string (required)
  ##         : The ID of the replication link to be failed over.
  var path_568232 = newJObject()
  var query_568233 = newJObject()
  add(path_568232, "resourceGroupName", newJString(resourceGroupName))
  add(query_568233, "api-version", newJString(apiVersion))
  add(path_568232, "serverName", newJString(serverName))
  add(path_568232, "subscriptionId", newJString(subscriptionId))
  add(path_568232, "databaseName", newJString(databaseName))
  add(path_568232, "linkId", newJString(linkId))
  result = call_568231.call(path_568232, query_568233, nil, nil, nil)

var replicationLinksFailover* = Call_ReplicationLinksFailover_568221(
    name: "replicationLinksFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/replicationLinks/{linkId}/failover",
    validator: validate_ReplicationLinksFailover_568222, base: "",
    url: url_ReplicationLinksFailover_568223, schemes: {Scheme.Https})
type
  Call_ReplicationLinksFailoverAllowDataLoss_568234 = ref object of OpenApiRestCall_567658
proc url_ReplicationLinksFailoverAllowDataLoss_568236(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/replicationLinks/"),
               (kind: VariableSegment, value: "linkId"),
               (kind: ConstantSegment, value: "/forceFailoverAllowDataLoss")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationLinksFailoverAllowDataLoss_568235(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets which replica database is primary by failing over from the current primary replica database. This operation might result in data loss.
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
  ##   databaseName: JString (required)
  ##               : The name of the database that has the replication link to be failed over.
  ##   linkId: JString (required)
  ##         : The ID of the replication link to be failed over.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568237 = path.getOrDefault("resourceGroupName")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "resourceGroupName", valid_568237
  var valid_568238 = path.getOrDefault("serverName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "serverName", valid_568238
  var valid_568239 = path.getOrDefault("subscriptionId")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "subscriptionId", valid_568239
  var valid_568240 = path.getOrDefault("databaseName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "databaseName", valid_568240
  var valid_568241 = path.getOrDefault("linkId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "linkId", valid_568241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568242 = query.getOrDefault("api-version")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "api-version", valid_568242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568243: Call_ReplicationLinksFailoverAllowDataLoss_568234;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets which replica database is primary by failing over from the current primary replica database. This operation might result in data loss.
  ## 
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_ReplicationLinksFailoverAllowDataLoss_568234;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string; linkId: string): Recallable =
  ## replicationLinksFailoverAllowDataLoss
  ## Sets which replica database is primary by failing over from the current primary replica database. This operation might result in data loss.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database that has the replication link to be failed over.
  ##   linkId: string (required)
  ##         : The ID of the replication link to be failed over.
  var path_568245 = newJObject()
  var query_568246 = newJObject()
  add(path_568245, "resourceGroupName", newJString(resourceGroupName))
  add(query_568246, "api-version", newJString(apiVersion))
  add(path_568245, "serverName", newJString(serverName))
  add(path_568245, "subscriptionId", newJString(subscriptionId))
  add(path_568245, "databaseName", newJString(databaseName))
  add(path_568245, "linkId", newJString(linkId))
  result = call_568244.call(path_568245, query_568246, nil, nil, nil)

var replicationLinksFailoverAllowDataLoss* = Call_ReplicationLinksFailoverAllowDataLoss_568234(
    name: "replicationLinksFailoverAllowDataLoss", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/replicationLinks/{linkId}/forceFailoverAllowDataLoss",
    validator: validate_ReplicationLinksFailoverAllowDataLoss_568235, base: "",
    url: url_ReplicationLinksFailoverAllowDataLoss_568236, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
