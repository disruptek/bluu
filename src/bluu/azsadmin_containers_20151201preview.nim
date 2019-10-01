
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: StorageManagementClient
## version: 2015-12-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Admin Storage Management Client.
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

  OpenApiRestCall_574458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574458): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-containers"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContainersCancelMigration_574986 = ref object of OpenApiRestCall_574458
proc url_ContainersCancelMigration_574988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/shares/operationresults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainersCancelMigration_574987(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel a container migration job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   operationId: JString (required)
  ##              : Operation Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574989 = path.getOrDefault("resourceGroupName")
  valid_574989 = validateParameter(valid_574989, JString, required = true,
                                 default = nil)
  if valid_574989 != nil:
    section.add "resourceGroupName", valid_574989
  var valid_574990 = path.getOrDefault("farmId")
  valid_574990 = validateParameter(valid_574990, JString, required = true,
                                 default = nil)
  if valid_574990 != nil:
    section.add "farmId", valid_574990
  var valid_574991 = path.getOrDefault("subscriptionId")
  valid_574991 = validateParameter(valid_574991, JString, required = true,
                                 default = nil)
  if valid_574991 != nil:
    section.add "subscriptionId", valid_574991
  var valid_574992 = path.getOrDefault("operationId")
  valid_574992 = validateParameter(valid_574992, JString, required = true,
                                 default = nil)
  if valid_574992 != nil:
    section.add "operationId", valid_574992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574993 = query.getOrDefault("api-version")
  valid_574993 = validateParameter(valid_574993, JString, required = true,
                                 default = nil)
  if valid_574993 != nil:
    section.add "api-version", valid_574993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574994: Call_ContainersCancelMigration_574986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a container migration job.
  ## 
  let valid = call_574994.validator(path, query, header, formData, body)
  let scheme = call_574994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574994.url(scheme.get, call_574994.host, call_574994.base,
                         call_574994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574994, url, valid)

proc call*(call_574995: Call_ContainersCancelMigration_574986;
          resourceGroupName: string; apiVersion: string; farmId: string;
          subscriptionId: string; operationId: string): Recallable =
  ## containersCancelMigration
  ## Cancel a container migration job.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   operationId: string (required)
  ##              : Operation Id.
  var path_574996 = newJObject()
  var query_574997 = newJObject()
  add(path_574996, "resourceGroupName", newJString(resourceGroupName))
  add(query_574997, "api-version", newJString(apiVersion))
  add(path_574996, "farmId", newJString(farmId))
  add(path_574996, "subscriptionId", newJString(subscriptionId))
  add(path_574996, "operationId", newJString(operationId))
  result = call_574995.call(path_574996, query_574997, nil, nil, nil)

var containersCancelMigration* = Call_ContainersCancelMigration_574986(
    name: "containersCancelMigration", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/shares/operationresults/{operationId}",
    validator: validate_ContainersCancelMigration_574987, base: "",
    url: url_ContainersCancelMigration_574988, schemes: {Scheme.Https})
type
  Call_ContainersMigrationStatus_574680 = ref object of OpenApiRestCall_574458
proc url_ContainersMigrationStatus_574682(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/shares/operationresults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainersMigrationStatus_574681(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the status of a container migration job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   operationId: JString (required)
  ##              : Operation Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574842 = path.getOrDefault("resourceGroupName")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = nil)
  if valid_574842 != nil:
    section.add "resourceGroupName", valid_574842
  var valid_574843 = path.getOrDefault("farmId")
  valid_574843 = validateParameter(valid_574843, JString, required = true,
                                 default = nil)
  if valid_574843 != nil:
    section.add "farmId", valid_574843
  var valid_574844 = path.getOrDefault("subscriptionId")
  valid_574844 = validateParameter(valid_574844, JString, required = true,
                                 default = nil)
  if valid_574844 != nil:
    section.add "subscriptionId", valid_574844
  var valid_574845 = path.getOrDefault("operationId")
  valid_574845 = validateParameter(valid_574845, JString, required = true,
                                 default = nil)
  if valid_574845 != nil:
    section.add "operationId", valid_574845
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574846 = query.getOrDefault("api-version")
  valid_574846 = validateParameter(valid_574846, JString, required = true,
                                 default = nil)
  if valid_574846 != nil:
    section.add "api-version", valid_574846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574873: Call_ContainersMigrationStatus_574680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the status of a container migration job.
  ## 
  let valid = call_574873.validator(path, query, header, formData, body)
  let scheme = call_574873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574873.url(scheme.get, call_574873.host, call_574873.base,
                         call_574873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574873, url, valid)

proc call*(call_574944: Call_ContainersMigrationStatus_574680;
          resourceGroupName: string; apiVersion: string; farmId: string;
          subscriptionId: string; operationId: string): Recallable =
  ## containersMigrationStatus
  ## Returns the status of a container migration job.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   operationId: string (required)
  ##              : Operation Id.
  var path_574945 = newJObject()
  var query_574947 = newJObject()
  add(path_574945, "resourceGroupName", newJString(resourceGroupName))
  add(query_574947, "api-version", newJString(apiVersion))
  add(path_574945, "farmId", newJString(farmId))
  add(path_574945, "subscriptionId", newJString(subscriptionId))
  add(path_574945, "operationId", newJString(operationId))
  result = call_574944.call(path_574945, query_574947, nil, nil, nil)

var containersMigrationStatus* = Call_ContainersMigrationStatus_574680(
    name: "containersMigrationStatus", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/shares/operationresults/{operationId}",
    validator: validate_ContainersMigrationStatus_574681, base: "",
    url: url_ContainersMigrationStatus_574682, schemes: {Scheme.Https})
type
  Call_ContainersList_574998 = ref object of OpenApiRestCall_574458
proc url_ContainersList_575000(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/containers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainersList_574999(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns the list of containers which can be migrated in the specified share.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   shareName: JString (required)
  ##            : Share name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575010 = path.getOrDefault("resourceGroupName")
  valid_575010 = validateParameter(valid_575010, JString, required = true,
                                 default = nil)
  if valid_575010 != nil:
    section.add "resourceGroupName", valid_575010
  var valid_575011 = path.getOrDefault("farmId")
  valid_575011 = validateParameter(valid_575011, JString, required = true,
                                 default = nil)
  if valid_575011 != nil:
    section.add "farmId", valid_575011
  var valid_575012 = path.getOrDefault("subscriptionId")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = nil)
  if valid_575012 != nil:
    section.add "subscriptionId", valid_575012
  var valid_575013 = path.getOrDefault("shareName")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "shareName", valid_575013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  ##   MaxCount: JInt
  ##           : The maximum number of containers.
  ##   StartIndex: JInt
  ##             : The starting index the resource provider uses.
  ##   Intent: JString (required)
  ##         : The container migration intent.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575014 = query.getOrDefault("api-version")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "api-version", valid_575014
  var valid_575015 = query.getOrDefault("MaxCount")
  valid_575015 = validateParameter(valid_575015, JInt, required = false, default = nil)
  if valid_575015 != nil:
    section.add "MaxCount", valid_575015
  var valid_575016 = query.getOrDefault("StartIndex")
  valid_575016 = validateParameter(valid_575016, JInt, required = false, default = nil)
  if valid_575016 != nil:
    section.add "StartIndex", valid_575016
  var valid_575017 = query.getOrDefault("Intent")
  valid_575017 = validateParameter(valid_575017, JString, required = true,
                                 default = nil)
  if valid_575017 != nil:
    section.add "Intent", valid_575017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575018: Call_ContainersList_574998; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of containers which can be migrated in the specified share.
  ## 
  let valid = call_575018.validator(path, query, header, formData, body)
  let scheme = call_575018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575018.url(scheme.get, call_575018.host, call_575018.base,
                         call_575018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575018, url, valid)

proc call*(call_575019: Call_ContainersList_574998; resourceGroupName: string;
          apiVersion: string; farmId: string; subscriptionId: string;
          shareName: string; Intent: string; MaxCount: int = 0; StartIndex: int = 0): Recallable =
  ## containersList
  ## Returns the list of containers which can be migrated in the specified share.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   shareName: string (required)
  ##            : Share name.
  ##   MaxCount: int
  ##           : The maximum number of containers.
  ##   StartIndex: int
  ##             : The starting index the resource provider uses.
  ##   Intent: string (required)
  ##         : The container migration intent.
  var path_575020 = newJObject()
  var query_575021 = newJObject()
  add(path_575020, "resourceGroupName", newJString(resourceGroupName))
  add(query_575021, "api-version", newJString(apiVersion))
  add(path_575020, "farmId", newJString(farmId))
  add(path_575020, "subscriptionId", newJString(subscriptionId))
  add(path_575020, "shareName", newJString(shareName))
  add(query_575021, "MaxCount", newJInt(MaxCount))
  add(query_575021, "StartIndex", newJInt(StartIndex))
  add(query_575021, "Intent", newJString(Intent))
  result = call_575019.call(path_575020, query_575021, nil, nil, nil)

var containersList* = Call_ContainersList_574998(name: "containersList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/shares/{shareName}/containers",
    validator: validate_ContainersList_574999, base: "", url: url_ContainersList_575000,
    schemes: {Scheme.Https})
type
  Call_ContainersListDestinationShares_575022 = ref object of OpenApiRestCall_574458
proc url_ContainersListDestinationShares_575024(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/destinationshares")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainersListDestinationShares_575023(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of destination shares that the system considers as best candidates for migration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   shareName: JString (required)
  ##            : Share name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575025 = path.getOrDefault("resourceGroupName")
  valid_575025 = validateParameter(valid_575025, JString, required = true,
                                 default = nil)
  if valid_575025 != nil:
    section.add "resourceGroupName", valid_575025
  var valid_575026 = path.getOrDefault("farmId")
  valid_575026 = validateParameter(valid_575026, JString, required = true,
                                 default = nil)
  if valid_575026 != nil:
    section.add "farmId", valid_575026
  var valid_575027 = path.getOrDefault("subscriptionId")
  valid_575027 = validateParameter(valid_575027, JString, required = true,
                                 default = nil)
  if valid_575027 != nil:
    section.add "subscriptionId", valid_575027
  var valid_575028 = path.getOrDefault("shareName")
  valid_575028 = validateParameter(valid_575028, JString, required = true,
                                 default = nil)
  if valid_575028 != nil:
    section.add "shareName", valid_575028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575029 = query.getOrDefault("api-version")
  valid_575029 = validateParameter(valid_575029, JString, required = true,
                                 default = nil)
  if valid_575029 != nil:
    section.add "api-version", valid_575029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575030: Call_ContainersListDestinationShares_575022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of destination shares that the system considers as best candidates for migration.
  ## 
  let valid = call_575030.validator(path, query, header, formData, body)
  let scheme = call_575030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575030.url(scheme.get, call_575030.host, call_575030.base,
                         call_575030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575030, url, valid)

proc call*(call_575031: Call_ContainersListDestinationShares_575022;
          resourceGroupName: string; apiVersion: string; farmId: string;
          subscriptionId: string; shareName: string): Recallable =
  ## containersListDestinationShares
  ## Returns a list of destination shares that the system considers as best candidates for migration.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   shareName: string (required)
  ##            : Share name.
  var path_575032 = newJObject()
  var query_575033 = newJObject()
  add(path_575032, "resourceGroupName", newJString(resourceGroupName))
  add(query_575033, "api-version", newJString(apiVersion))
  add(path_575032, "farmId", newJString(farmId))
  add(path_575032, "subscriptionId", newJString(subscriptionId))
  add(path_575032, "shareName", newJString(shareName))
  result = call_575031.call(path_575032, query_575033, nil, nil, nil)

var containersListDestinationShares* = Call_ContainersListDestinationShares_575022(
    name: "containersListDestinationShares", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/shares/{shareName}/destinationshares",
    validator: validate_ContainersListDestinationShares_575023, base: "",
    url: url_ContainersListDestinationShares_575024, schemes: {Scheme.Https})
type
  Call_ContainersMigrate_575034 = ref object of OpenApiRestCall_574458
proc url_ContainersMigrate_575036(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/migrate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainersMigrate_575035(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Starts a container migration job to migrate containers to the specified destination share.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   shareName: JString (required)
  ##            : Share name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575037 = path.getOrDefault("resourceGroupName")
  valid_575037 = validateParameter(valid_575037, JString, required = true,
                                 default = nil)
  if valid_575037 != nil:
    section.add "resourceGroupName", valid_575037
  var valid_575038 = path.getOrDefault("farmId")
  valid_575038 = validateParameter(valid_575038, JString, required = true,
                                 default = nil)
  if valid_575038 != nil:
    section.add "farmId", valid_575038
  var valid_575039 = path.getOrDefault("subscriptionId")
  valid_575039 = validateParameter(valid_575039, JString, required = true,
                                 default = nil)
  if valid_575039 != nil:
    section.add "subscriptionId", valid_575039
  var valid_575040 = path.getOrDefault("shareName")
  valid_575040 = validateParameter(valid_575040, JString, required = true,
                                 default = nil)
  if valid_575040 != nil:
    section.add "shareName", valid_575040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575041 = query.getOrDefault("api-version")
  valid_575041 = validateParameter(valid_575041, JString, required = true,
                                 default = nil)
  if valid_575041 != nil:
    section.add "api-version", valid_575041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   migrationParameters: JObject (required)
  ##                      : The parameters of container migration job.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575043: Call_ContainersMigrate_575034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a container migration job to migrate containers to the specified destination share.
  ## 
  let valid = call_575043.validator(path, query, header, formData, body)
  let scheme = call_575043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575043.url(scheme.get, call_575043.host, call_575043.base,
                         call_575043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575043, url, valid)

proc call*(call_575044: Call_ContainersMigrate_575034; resourceGroupName: string;
          apiVersion: string; farmId: string; migrationParameters: JsonNode;
          subscriptionId: string; shareName: string): Recallable =
  ## containersMigrate
  ## Starts a container migration job to migrate containers to the specified destination share.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   migrationParameters: JObject (required)
  ##                      : The parameters of container migration job.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   shareName: string (required)
  ##            : Share name.
  var path_575045 = newJObject()
  var query_575046 = newJObject()
  var body_575047 = newJObject()
  add(path_575045, "resourceGroupName", newJString(resourceGroupName))
  add(query_575046, "api-version", newJString(apiVersion))
  add(path_575045, "farmId", newJString(farmId))
  if migrationParameters != nil:
    body_575047 = migrationParameters
  add(path_575045, "subscriptionId", newJString(subscriptionId))
  add(path_575045, "shareName", newJString(shareName))
  result = call_575044.call(path_575045, query_575046, nil, nil, body_575047)

var containersMigrate* = Call_ContainersMigrate_575034(name: "containersMigrate",
    meth: HttpMethod.HttpPost, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/shares/{shareName}/migrate",
    validator: validate_ContainersMigrate_575035, base: "",
    url: url_ContainersMigrate_575036, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
