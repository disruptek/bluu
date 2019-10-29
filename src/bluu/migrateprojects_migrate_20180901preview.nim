
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Migrate Hub
## version: 2018-09-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Migrate your workloads to Azure.
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

  OpenApiRestCall_563565 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563565](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563565): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "migrateprojects-migrate"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563787 = ref object of OpenApiRestCall_563565
proc url_OperationsList_563789(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563788(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563894: Call_OperationsList_563787; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  ## 
  let valid = call_563894.validator(path, query, header, formData, body)
  let scheme = call_563894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563894.url(scheme.get, call_563894.host, call_563894.base,
                         call_563894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563894, url, valid)

proc call*(call_563978: Call_OperationsList_563787): Recallable =
  ## operationsList
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  result = call_563978.call(nil, nil, nil, nil, nil)

var operationsList* = Call_OperationsList_563787(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Migrate/operations",
    validator: validate_OperationsList_563788, base: "", url: url_OperationsList_563789,
    schemes: {Scheme.Https})
type
  Call_MigrateProjectsPutMigrateProject_564121 = ref object of OpenApiRestCall_563565
proc url_MigrateProjectsPutMigrateProject_564123(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsPutMigrateProject_564122(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564124 = path.getOrDefault("subscriptionId")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "subscriptionId", valid_564124
  var valid_564125 = path.getOrDefault("migrateProjectName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "migrateProjectName", valid_564125
  var valid_564126 = path.getOrDefault("resourceGroupName")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "resourceGroupName", valid_564126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564127 = query.getOrDefault("api-version")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564127 != nil:
    section.add "api-version", valid_564127
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564128 = header.getOrDefault("Accept-Language")
  valid_564128 = validateParameter(valid_564128, JString, required = false,
                                 default = nil)
  if valid_564128 != nil:
    section.add "Accept-Language", valid_564128
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Body with migrate project details.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564130: Call_MigrateProjectsPutMigrateProject_564121;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564130.validator(path, query, header, formData, body)
  let scheme = call_564130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564130.url(scheme.get, call_564130.host, call_564130.base,
                         call_564130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564130, url, valid)

proc call*(call_564131: Call_MigrateProjectsPutMigrateProject_564121;
          subscriptionId: string; migrateProjectName: string;
          resourceGroupName: string; body: JsonNode;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsPutMigrateProject
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   body: JObject (required)
  ##       : Body with migrate project details.
  var path_564132 = newJObject()
  var query_564133 = newJObject()
  var body_564134 = newJObject()
  add(query_564133, "api-version", newJString(apiVersion))
  add(path_564132, "subscriptionId", newJString(subscriptionId))
  add(path_564132, "migrateProjectName", newJString(migrateProjectName))
  add(path_564132, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564134 = body
  result = call_564131.call(path_564132, query_564133, nil, nil, body_564134)

var migrateProjectsPutMigrateProject* = Call_MigrateProjectsPutMigrateProject_564121(
    name: "migrateProjectsPutMigrateProject", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}",
    validator: validate_MigrateProjectsPutMigrateProject_564122, base: "",
    url: url_MigrateProjectsPutMigrateProject_564123, schemes: {Scheme.Https})
type
  Call_MigrateProjectsGetMigrateProject_564016 = ref object of OpenApiRestCall_563565
proc url_MigrateProjectsGetMigrateProject_564018(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsGetMigrateProject_564017(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564098 = path.getOrDefault("subscriptionId")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "subscriptionId", valid_564098
  var valid_564099 = path.getOrDefault("migrateProjectName")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "migrateProjectName", valid_564099
  var valid_564100 = path.getOrDefault("resourceGroupName")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "resourceGroupName", valid_564100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564114 = query.getOrDefault("api-version")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564114 != nil:
    section.add "api-version", valid_564114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564115: Call_MigrateProjectsGetMigrateProject_564016;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564115.validator(path, query, header, formData, body)
  let scheme = call_564115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564115.url(scheme.get, call_564115.host, call_564115.base,
                         call_564115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564115, url, valid)

proc call*(call_564116: Call_MigrateProjectsGetMigrateProject_564016;
          subscriptionId: string; migrateProjectName: string;
          resourceGroupName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsGetMigrateProject
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564117 = newJObject()
  var query_564119 = newJObject()
  add(query_564119, "api-version", newJString(apiVersion))
  add(path_564117, "subscriptionId", newJString(subscriptionId))
  add(path_564117, "migrateProjectName", newJString(migrateProjectName))
  add(path_564117, "resourceGroupName", newJString(resourceGroupName))
  result = call_564116.call(path_564117, query_564119, nil, nil, nil)

var migrateProjectsGetMigrateProject* = Call_MigrateProjectsGetMigrateProject_564016(
    name: "migrateProjectsGetMigrateProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}",
    validator: validate_MigrateProjectsGetMigrateProject_564017, base: "",
    url: url_MigrateProjectsGetMigrateProject_564018, schemes: {Scheme.Https})
type
  Call_MigrateProjectsPatchMigrateProject_564147 = ref object of OpenApiRestCall_563565
proc url_MigrateProjectsPatchMigrateProject_564149(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsPatchMigrateProject_564148(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a migrate project with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564150 = path.getOrDefault("subscriptionId")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "subscriptionId", valid_564150
  var valid_564151 = path.getOrDefault("migrateProjectName")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "migrateProjectName", valid_564151
  var valid_564152 = path.getOrDefault("resourceGroupName")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "resourceGroupName", valid_564152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564153 = query.getOrDefault("api-version")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564153 != nil:
    section.add "api-version", valid_564153
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564154 = header.getOrDefault("Accept-Language")
  valid_564154 = validateParameter(valid_564154, JString, required = false,
                                 default = nil)
  if valid_564154 != nil:
    section.add "Accept-Language", valid_564154
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Body with migrate project details.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564156: Call_MigrateProjectsPatchMigrateProject_564147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a migrate project with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_MigrateProjectsPatchMigrateProject_564147;
          subscriptionId: string; migrateProjectName: string;
          resourceGroupName: string; body: JsonNode;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsPatchMigrateProject
  ## Update a migrate project with specified name. Supports partial updates, for example only tags can be provided.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   body: JObject (required)
  ##       : Body with migrate project details.
  var path_564158 = newJObject()
  var query_564159 = newJObject()
  var body_564160 = newJObject()
  add(query_564159, "api-version", newJString(apiVersion))
  add(path_564158, "subscriptionId", newJString(subscriptionId))
  add(path_564158, "migrateProjectName", newJString(migrateProjectName))
  add(path_564158, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564160 = body
  result = call_564157.call(path_564158, query_564159, nil, nil, body_564160)

var migrateProjectsPatchMigrateProject* = Call_MigrateProjectsPatchMigrateProject_564147(
    name: "migrateProjectsPatchMigrateProject", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}",
    validator: validate_MigrateProjectsPatchMigrateProject_564148, base: "",
    url: url_MigrateProjectsPatchMigrateProject_564149, schemes: {Scheme.Https})
type
  Call_MigrateProjectsDeleteMigrateProject_564135 = ref object of OpenApiRestCall_563565
proc url_MigrateProjectsDeleteMigrateProject_564137(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsDeleteMigrateProject_564136(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the migrate project. Deleting non-existent project is a no-operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564138 = path.getOrDefault("subscriptionId")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "subscriptionId", valid_564138
  var valid_564139 = path.getOrDefault("migrateProjectName")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "migrateProjectName", valid_564139
  var valid_564140 = path.getOrDefault("resourceGroupName")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "resourceGroupName", valid_564140
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564141 = query.getOrDefault("api-version")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564141 != nil:
    section.add "api-version", valid_564141
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564142 = header.getOrDefault("Accept-Language")
  valid_564142 = validateParameter(valid_564142, JString, required = false,
                                 default = nil)
  if valid_564142 != nil:
    section.add "Accept-Language", valid_564142
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564143: Call_MigrateProjectsDeleteMigrateProject_564135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the migrate project. Deleting non-existent project is a no-operation.
  ## 
  let valid = call_564143.validator(path, query, header, formData, body)
  let scheme = call_564143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564143.url(scheme.get, call_564143.host, call_564143.base,
                         call_564143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564143, url, valid)

proc call*(call_564144: Call_MigrateProjectsDeleteMigrateProject_564135;
          subscriptionId: string; migrateProjectName: string;
          resourceGroupName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsDeleteMigrateProject
  ## Delete the migrate project. Deleting non-existent project is a no-operation.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564145 = newJObject()
  var query_564146 = newJObject()
  add(query_564146, "api-version", newJString(apiVersion))
  add(path_564145, "subscriptionId", newJString(subscriptionId))
  add(path_564145, "migrateProjectName", newJString(migrateProjectName))
  add(path_564145, "resourceGroupName", newJString(resourceGroupName))
  result = call_564144.call(path_564145, query_564146, nil, nil, nil)

var migrateProjectsDeleteMigrateProject* = Call_MigrateProjectsDeleteMigrateProject_564135(
    name: "migrateProjectsDeleteMigrateProject", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}",
    validator: validate_MigrateProjectsDeleteMigrateProject_564136, base: "",
    url: url_MigrateProjectsDeleteMigrateProject_564137, schemes: {Scheme.Https})
type
  Call_DatabaseInstancesEnumerateDatabaseInstances_564161 = ref object of OpenApiRestCall_563565
proc url_DatabaseInstancesEnumerateDatabaseInstances_564163(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/databaseInstances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseInstancesEnumerateDatabaseInstances_564162(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564164 = path.getOrDefault("subscriptionId")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "subscriptionId", valid_564164
  var valid_564165 = path.getOrDefault("migrateProjectName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "migrateProjectName", valid_564165
  var valid_564166 = path.getOrDefault("resourceGroupName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "resourceGroupName", valid_564166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  ##   pageSize: JInt
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  ##   continuationToken: JString
  ##                    : The continuation token.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564167 = query.getOrDefault("api-version")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564167 != nil:
    section.add "api-version", valid_564167
  var valid_564168 = query.getOrDefault("pageSize")
  valid_564168 = validateParameter(valid_564168, JInt, required = false, default = nil)
  if valid_564168 != nil:
    section.add "pageSize", valid_564168
  var valid_564169 = query.getOrDefault("continuationToken")
  valid_564169 = validateParameter(valid_564169, JString, required = false,
                                 default = nil)
  if valid_564169 != nil:
    section.add "continuationToken", valid_564169
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564170 = header.getOrDefault("Accept-Language")
  valid_564170 = validateParameter(valid_564170, JString, required = false,
                                 default = nil)
  if valid_564170 != nil:
    section.add "Accept-Language", valid_564170
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564171: Call_DatabaseInstancesEnumerateDatabaseInstances_564161;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564171.validator(path, query, header, formData, body)
  let scheme = call_564171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564171.url(scheme.get, call_564171.host, call_564171.base,
                         call_564171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564171, url, valid)

proc call*(call_564172: Call_DatabaseInstancesEnumerateDatabaseInstances_564161;
          subscriptionId: string; migrateProjectName: string;
          resourceGroupName: string; apiVersion: string = "2018-09-01-preview";
          pageSize: int = 0; continuationToken: string = ""): Recallable =
  ## databaseInstancesEnumerateDatabaseInstances
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   pageSize: int
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564173 = newJObject()
  var query_564174 = newJObject()
  add(query_564174, "api-version", newJString(apiVersion))
  add(query_564174, "pageSize", newJInt(pageSize))
  add(path_564173, "subscriptionId", newJString(subscriptionId))
  add(query_564174, "continuationToken", newJString(continuationToken))
  add(path_564173, "migrateProjectName", newJString(migrateProjectName))
  add(path_564173, "resourceGroupName", newJString(resourceGroupName))
  result = call_564172.call(path_564173, query_564174, nil, nil, nil)

var databaseInstancesEnumerateDatabaseInstances* = Call_DatabaseInstancesEnumerateDatabaseInstances_564161(
    name: "databaseInstancesEnumerateDatabaseInstances", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/databaseInstances",
    validator: validate_DatabaseInstancesEnumerateDatabaseInstances_564162,
    base: "", url: url_DatabaseInstancesEnumerateDatabaseInstances_564163,
    schemes: {Scheme.Https})
type
  Call_DatabaseInstancesGetDatabaseInstance_564175 = ref object of OpenApiRestCall_563565
proc url_DatabaseInstancesGetDatabaseInstance_564177(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "databaseInstanceName" in path,
        "`databaseInstanceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/databaseInstances/"),
               (kind: VariableSegment, value: "databaseInstanceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseInstancesGetDatabaseInstance_564176(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseInstanceName: JString (required)
  ##                       : Unique name of a database instance in Azure migration hub.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `databaseInstanceName` field"
  var valid_564178 = path.getOrDefault("databaseInstanceName")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "databaseInstanceName", valid_564178
  var valid_564179 = path.getOrDefault("subscriptionId")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "subscriptionId", valid_564179
  var valid_564180 = path.getOrDefault("migrateProjectName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "migrateProjectName", valid_564180
  var valid_564181 = path.getOrDefault("resourceGroupName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "resourceGroupName", valid_564181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564182 = query.getOrDefault("api-version")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564182 != nil:
    section.add "api-version", valid_564182
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564183 = header.getOrDefault("Accept-Language")
  valid_564183 = validateParameter(valid_564183, JString, required = false,
                                 default = nil)
  if valid_564183 != nil:
    section.add "Accept-Language", valid_564183
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564184: Call_DatabaseInstancesGetDatabaseInstance_564175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564184.validator(path, query, header, formData, body)
  let scheme = call_564184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564184.url(scheme.get, call_564184.host, call_564184.base,
                         call_564184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564184, url, valid)

proc call*(call_564185: Call_DatabaseInstancesGetDatabaseInstance_564175;
          databaseInstanceName: string; subscriptionId: string;
          migrateProjectName: string; resourceGroupName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## databaseInstancesGetDatabaseInstance
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   databaseInstanceName: string (required)
  ##                       : Unique name of a database instance in Azure migration hub.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564186 = newJObject()
  var query_564187 = newJObject()
  add(query_564187, "api-version", newJString(apiVersion))
  add(path_564186, "databaseInstanceName", newJString(databaseInstanceName))
  add(path_564186, "subscriptionId", newJString(subscriptionId))
  add(path_564186, "migrateProjectName", newJString(migrateProjectName))
  add(path_564186, "resourceGroupName", newJString(resourceGroupName))
  result = call_564185.call(path_564186, query_564187, nil, nil, nil)

var databaseInstancesGetDatabaseInstance* = Call_DatabaseInstancesGetDatabaseInstance_564175(
    name: "databaseInstancesGetDatabaseInstance", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/databaseInstances/{databaseInstanceName}",
    validator: validate_DatabaseInstancesGetDatabaseInstance_564176, base: "",
    url: url_DatabaseInstancesGetDatabaseInstance_564177, schemes: {Scheme.Https})
type
  Call_DatabasesEnumerateDatabases_564188 = ref object of OpenApiRestCall_563565
proc url_DatabasesEnumerateDatabases_564190(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/databases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesEnumerateDatabases_564189(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564191 = path.getOrDefault("subscriptionId")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "subscriptionId", valid_564191
  var valid_564192 = path.getOrDefault("migrateProjectName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "migrateProjectName", valid_564192
  var valid_564193 = path.getOrDefault("resourceGroupName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "resourceGroupName", valid_564193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  ##   pageSize: JInt
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  ##   continuationToken: JString
  ##                    : The continuation token.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564194 = query.getOrDefault("api-version")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564194 != nil:
    section.add "api-version", valid_564194
  var valid_564195 = query.getOrDefault("pageSize")
  valid_564195 = validateParameter(valid_564195, JInt, required = false, default = nil)
  if valid_564195 != nil:
    section.add "pageSize", valid_564195
  var valid_564196 = query.getOrDefault("continuationToken")
  valid_564196 = validateParameter(valid_564196, JString, required = false,
                                 default = nil)
  if valid_564196 != nil:
    section.add "continuationToken", valid_564196
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564197 = header.getOrDefault("Accept-Language")
  valid_564197 = validateParameter(valid_564197, JString, required = false,
                                 default = nil)
  if valid_564197 != nil:
    section.add "Accept-Language", valid_564197
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564198: Call_DatabasesEnumerateDatabases_564188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564198.validator(path, query, header, formData, body)
  let scheme = call_564198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564198.url(scheme.get, call_564198.host, call_564198.base,
                         call_564198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564198, url, valid)

proc call*(call_564199: Call_DatabasesEnumerateDatabases_564188;
          subscriptionId: string; migrateProjectName: string;
          resourceGroupName: string; apiVersion: string = "2018-09-01-preview";
          pageSize: int = 0; continuationToken: string = ""): Recallable =
  ## databasesEnumerateDatabases
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   pageSize: int
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564200 = newJObject()
  var query_564201 = newJObject()
  add(query_564201, "api-version", newJString(apiVersion))
  add(query_564201, "pageSize", newJInt(pageSize))
  add(path_564200, "subscriptionId", newJString(subscriptionId))
  add(query_564201, "continuationToken", newJString(continuationToken))
  add(path_564200, "migrateProjectName", newJString(migrateProjectName))
  add(path_564200, "resourceGroupName", newJString(resourceGroupName))
  result = call_564199.call(path_564200, query_564201, nil, nil, nil)

var databasesEnumerateDatabases* = Call_DatabasesEnumerateDatabases_564188(
    name: "databasesEnumerateDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/databases",
    validator: validate_DatabasesEnumerateDatabases_564189, base: "",
    url: url_DatabasesEnumerateDatabases_564190, schemes: {Scheme.Https})
type
  Call_DatabasesGetDatabase_564202 = ref object of OpenApiRestCall_563565
proc url_DatabasesGetDatabase_564204(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesGetDatabase_564203(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   databaseName: JString (required)
  ##               : Unique name of a database in Azure migration hub.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564205 = path.getOrDefault("subscriptionId")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "subscriptionId", valid_564205
  var valid_564206 = path.getOrDefault("databaseName")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "databaseName", valid_564206
  var valid_564207 = path.getOrDefault("migrateProjectName")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "migrateProjectName", valid_564207
  var valid_564208 = path.getOrDefault("resourceGroupName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "resourceGroupName", valid_564208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564209 = query.getOrDefault("api-version")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564209 != nil:
    section.add "api-version", valid_564209
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564210 = header.getOrDefault("Accept-Language")
  valid_564210 = validateParameter(valid_564210, JString, required = false,
                                 default = nil)
  if valid_564210 != nil:
    section.add "Accept-Language", valid_564210
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564211: Call_DatabasesGetDatabase_564202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564211.validator(path, query, header, formData, body)
  let scheme = call_564211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564211.url(scheme.get, call_564211.host, call_564211.base,
                         call_564211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564211, url, valid)

proc call*(call_564212: Call_DatabasesGetDatabase_564202; subscriptionId: string;
          databaseName: string; migrateProjectName: string;
          resourceGroupName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## databasesGetDatabase
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   databaseName: string (required)
  ##               : Unique name of a database in Azure migration hub.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564213 = newJObject()
  var query_564214 = newJObject()
  add(query_564214, "api-version", newJString(apiVersion))
  add(path_564213, "subscriptionId", newJString(subscriptionId))
  add(path_564213, "databaseName", newJString(databaseName))
  add(path_564213, "migrateProjectName", newJString(migrateProjectName))
  add(path_564213, "resourceGroupName", newJString(resourceGroupName))
  result = call_564212.call(path_564213, query_564214, nil, nil, nil)

var databasesGetDatabase* = Call_DatabasesGetDatabase_564202(
    name: "databasesGetDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/databases/{databaseName}",
    validator: validate_DatabasesGetDatabase_564203, base: "",
    url: url_DatabasesGetDatabase_564204, schemes: {Scheme.Https})
type
  Call_MachinesEnumerateMachines_564215 = ref object of OpenApiRestCall_563565
proc url_MachinesEnumerateMachines_564217(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/machines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesEnumerateMachines_564216(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564218 = path.getOrDefault("subscriptionId")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "subscriptionId", valid_564218
  var valid_564219 = path.getOrDefault("migrateProjectName")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "migrateProjectName", valid_564219
  var valid_564220 = path.getOrDefault("resourceGroupName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "resourceGroupName", valid_564220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  ##   pageSize: JInt
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  ##   continuationToken: JString
  ##                    : The continuation token.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564221 = query.getOrDefault("api-version")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564221 != nil:
    section.add "api-version", valid_564221
  var valid_564222 = query.getOrDefault("pageSize")
  valid_564222 = validateParameter(valid_564222, JInt, required = false, default = nil)
  if valid_564222 != nil:
    section.add "pageSize", valid_564222
  var valid_564223 = query.getOrDefault("continuationToken")
  valid_564223 = validateParameter(valid_564223, JString, required = false,
                                 default = nil)
  if valid_564223 != nil:
    section.add "continuationToken", valid_564223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564224: Call_MachinesEnumerateMachines_564215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564224.validator(path, query, header, formData, body)
  let scheme = call_564224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564224.url(scheme.get, call_564224.host, call_564224.base,
                         call_564224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564224, url, valid)

proc call*(call_564225: Call_MachinesEnumerateMachines_564215;
          subscriptionId: string; migrateProjectName: string;
          resourceGroupName: string; apiVersion: string = "2018-09-01-preview";
          pageSize: int = 0; continuationToken: string = ""): Recallable =
  ## machinesEnumerateMachines
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   pageSize: int
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564226 = newJObject()
  var query_564227 = newJObject()
  add(query_564227, "api-version", newJString(apiVersion))
  add(query_564227, "pageSize", newJInt(pageSize))
  add(path_564226, "subscriptionId", newJString(subscriptionId))
  add(query_564227, "continuationToken", newJString(continuationToken))
  add(path_564226, "migrateProjectName", newJString(migrateProjectName))
  add(path_564226, "resourceGroupName", newJString(resourceGroupName))
  result = call_564225.call(path_564226, query_564227, nil, nil, nil)

var machinesEnumerateMachines* = Call_MachinesEnumerateMachines_564215(
    name: "machinesEnumerateMachines", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/machines",
    validator: validate_MachinesEnumerateMachines_564216, base: "",
    url: url_MachinesEnumerateMachines_564217, schemes: {Scheme.Https})
type
  Call_MachinesGetMachine_564228 = ref object of OpenApiRestCall_563565
proc url_MachinesGetMachine_564230(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/machines/"),
               (kind: VariableSegment, value: "machineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesGetMachine_564229(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineName: JString (required)
  ##              : Unique name of a machine in Azure migration hub.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineName` field"
  var valid_564231 = path.getOrDefault("machineName")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "machineName", valid_564231
  var valid_564232 = path.getOrDefault("subscriptionId")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "subscriptionId", valid_564232
  var valid_564233 = path.getOrDefault("migrateProjectName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "migrateProjectName", valid_564233
  var valid_564234 = path.getOrDefault("resourceGroupName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "resourceGroupName", valid_564234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564235 = query.getOrDefault("api-version")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564235 != nil:
    section.add "api-version", valid_564235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564236: Call_MachinesGetMachine_564228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564236.validator(path, query, header, formData, body)
  let scheme = call_564236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564236.url(scheme.get, call_564236.host, call_564236.base,
                         call_564236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564236, url, valid)

proc call*(call_564237: Call_MachinesGetMachine_564228; machineName: string;
          subscriptionId: string; migrateProjectName: string;
          resourceGroupName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## machinesGetMachine
  ##   machineName: string (required)
  ##              : Unique name of a machine in Azure migration hub.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564238 = newJObject()
  var query_564239 = newJObject()
  add(path_564238, "machineName", newJString(machineName))
  add(query_564239, "api-version", newJString(apiVersion))
  add(path_564238, "subscriptionId", newJString(subscriptionId))
  add(path_564238, "migrateProjectName", newJString(migrateProjectName))
  add(path_564238, "resourceGroupName", newJString(resourceGroupName))
  result = call_564237.call(path_564238, query_564239, nil, nil, nil)

var machinesGetMachine* = Call_MachinesGetMachine_564228(
    name: "machinesGetMachine", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/machines/{machineName}",
    validator: validate_MachinesGetMachine_564229, base: "",
    url: url_MachinesGetMachine_564230, schemes: {Scheme.Https})
type
  Call_EventsEnumerateEvents_564240 = ref object of OpenApiRestCall_563565
proc url_EventsEnumerateEvents_564242(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/migrateEvents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsEnumerateEvents_564241(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564243 = path.getOrDefault("subscriptionId")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "subscriptionId", valid_564243
  var valid_564244 = path.getOrDefault("migrateProjectName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "migrateProjectName", valid_564244
  var valid_564245 = path.getOrDefault("resourceGroupName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "resourceGroupName", valid_564245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  ##   pageSize: JInt
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  ##   continuationToken: JString
  ##                    : The continuation token.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564246 = query.getOrDefault("api-version")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564246 != nil:
    section.add "api-version", valid_564246
  var valid_564247 = query.getOrDefault("pageSize")
  valid_564247 = validateParameter(valid_564247, JInt, required = false, default = nil)
  if valid_564247 != nil:
    section.add "pageSize", valid_564247
  var valid_564248 = query.getOrDefault("continuationToken")
  valid_564248 = validateParameter(valid_564248, JString, required = false,
                                 default = nil)
  if valid_564248 != nil:
    section.add "continuationToken", valid_564248
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564249 = header.getOrDefault("Accept-Language")
  valid_564249 = validateParameter(valid_564249, JString, required = false,
                                 default = nil)
  if valid_564249 != nil:
    section.add "Accept-Language", valid_564249
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564250: Call_EventsEnumerateEvents_564240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564250.validator(path, query, header, formData, body)
  let scheme = call_564250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564250.url(scheme.get, call_564250.host, call_564250.base,
                         call_564250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564250, url, valid)

proc call*(call_564251: Call_EventsEnumerateEvents_564240; subscriptionId: string;
          migrateProjectName: string; resourceGroupName: string;
          apiVersion: string = "2018-09-01-preview"; pageSize: int = 0;
          continuationToken: string = ""): Recallable =
  ## eventsEnumerateEvents
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   pageSize: int
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564252 = newJObject()
  var query_564253 = newJObject()
  add(query_564253, "api-version", newJString(apiVersion))
  add(query_564253, "pageSize", newJInt(pageSize))
  add(path_564252, "subscriptionId", newJString(subscriptionId))
  add(query_564253, "continuationToken", newJString(continuationToken))
  add(path_564252, "migrateProjectName", newJString(migrateProjectName))
  add(path_564252, "resourceGroupName", newJString(resourceGroupName))
  result = call_564251.call(path_564252, query_564253, nil, nil, nil)

var eventsEnumerateEvents* = Call_EventsEnumerateEvents_564240(
    name: "eventsEnumerateEvents", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/migrateEvents",
    validator: validate_EventsEnumerateEvents_564241, base: "",
    url: url_EventsEnumerateEvents_564242, schemes: {Scheme.Https})
type
  Call_EventsGetEvent_564254 = ref object of OpenApiRestCall_563565
proc url_EventsGetEvent_564256(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "eventName" in path, "`eventName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/migrateEvents/"),
               (kind: VariableSegment, value: "eventName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsGetEvent_564255(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   eventName: JString (required)
  ##            : Unique name of an event within a migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564257 = path.getOrDefault("subscriptionId")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "subscriptionId", valid_564257
  var valid_564258 = path.getOrDefault("migrateProjectName")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "migrateProjectName", valid_564258
  var valid_564259 = path.getOrDefault("resourceGroupName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "resourceGroupName", valid_564259
  var valid_564260 = path.getOrDefault("eventName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "eventName", valid_564260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564261 = query.getOrDefault("api-version")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564261 != nil:
    section.add "api-version", valid_564261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564262: Call_EventsGetEvent_564254; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564262.validator(path, query, header, formData, body)
  let scheme = call_564262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564262.url(scheme.get, call_564262.host, call_564262.base,
                         call_564262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564262, url, valid)

proc call*(call_564263: Call_EventsGetEvent_564254; subscriptionId: string;
          migrateProjectName: string; resourceGroupName: string; eventName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## eventsGetEvent
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   eventName: string (required)
  ##            : Unique name of an event within a migrate project.
  var path_564264 = newJObject()
  var query_564265 = newJObject()
  add(query_564265, "api-version", newJString(apiVersion))
  add(path_564264, "subscriptionId", newJString(subscriptionId))
  add(path_564264, "migrateProjectName", newJString(migrateProjectName))
  add(path_564264, "resourceGroupName", newJString(resourceGroupName))
  add(path_564264, "eventName", newJString(eventName))
  result = call_564263.call(path_564264, query_564265, nil, nil, nil)

var eventsGetEvent* = Call_EventsGetEvent_564254(name: "eventsGetEvent",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/migrateEvents/{eventName}",
    validator: validate_EventsGetEvent_564255, base: "", url: url_EventsGetEvent_564256,
    schemes: {Scheme.Https})
type
  Call_EventsDeleteEvent_564266 = ref object of OpenApiRestCall_563565
proc url_EventsDeleteEvent_564268(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "eventName" in path, "`eventName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/migrateEvents/"),
               (kind: VariableSegment, value: "eventName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsDeleteEvent_564267(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete the migrate event. Deleting non-existent migrate event is a no-operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   eventName: JString (required)
  ##            : Unique name of an event within a migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564269 = path.getOrDefault("subscriptionId")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "subscriptionId", valid_564269
  var valid_564270 = path.getOrDefault("migrateProjectName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "migrateProjectName", valid_564270
  var valid_564271 = path.getOrDefault("resourceGroupName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "resourceGroupName", valid_564271
  var valid_564272 = path.getOrDefault("eventName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "eventName", valid_564272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564273 = query.getOrDefault("api-version")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564273 != nil:
    section.add "api-version", valid_564273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564274: Call_EventsDeleteEvent_564266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the migrate event. Deleting non-existent migrate event is a no-operation.
  ## 
  let valid = call_564274.validator(path, query, header, formData, body)
  let scheme = call_564274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564274.url(scheme.get, call_564274.host, call_564274.base,
                         call_564274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564274, url, valid)

proc call*(call_564275: Call_EventsDeleteEvent_564266; subscriptionId: string;
          migrateProjectName: string; resourceGroupName: string; eventName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## eventsDeleteEvent
  ## Delete the migrate event. Deleting non-existent migrate event is a no-operation.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   eventName: string (required)
  ##            : Unique name of an event within a migrate project.
  var path_564276 = newJObject()
  var query_564277 = newJObject()
  add(query_564277, "api-version", newJString(apiVersion))
  add(path_564276, "subscriptionId", newJString(subscriptionId))
  add(path_564276, "migrateProjectName", newJString(migrateProjectName))
  add(path_564276, "resourceGroupName", newJString(resourceGroupName))
  add(path_564276, "eventName", newJString(eventName))
  result = call_564275.call(path_564276, query_564277, nil, nil, nil)

var eventsDeleteEvent* = Call_EventsDeleteEvent_564266(name: "eventsDeleteEvent",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/migrateEvents/{eventName}",
    validator: validate_EventsDeleteEvent_564267, base: "",
    url: url_EventsDeleteEvent_564268, schemes: {Scheme.Https})
type
  Call_MigrateProjectsRefreshMigrateProjectSummary_564278 = ref object of OpenApiRestCall_563565
proc url_MigrateProjectsRefreshMigrateProjectSummary_564280(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/refreshSummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsRefreshMigrateProjectSummary_564279(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564281 = path.getOrDefault("subscriptionId")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "subscriptionId", valid_564281
  var valid_564282 = path.getOrDefault("migrateProjectName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "migrateProjectName", valid_564282
  var valid_564283 = path.getOrDefault("resourceGroupName")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "resourceGroupName", valid_564283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564284 = query.getOrDefault("api-version")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564284 != nil:
    section.add "api-version", valid_564284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : The goal input which needs to be refreshed.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564286: Call_MigrateProjectsRefreshMigrateProjectSummary_564278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564286.validator(path, query, header, formData, body)
  let scheme = call_564286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564286.url(scheme.get, call_564286.host, call_564286.base,
                         call_564286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564286, url, valid)

proc call*(call_564287: Call_MigrateProjectsRefreshMigrateProjectSummary_564278;
          input: JsonNode; subscriptionId: string; migrateProjectName: string;
          resourceGroupName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsRefreshMigrateProjectSummary
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   input: JObject (required)
  ##        : The goal input which needs to be refreshed.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564288 = newJObject()
  var query_564289 = newJObject()
  var body_564290 = newJObject()
  add(query_564289, "api-version", newJString(apiVersion))
  if input != nil:
    body_564290 = input
  add(path_564288, "subscriptionId", newJString(subscriptionId))
  add(path_564288, "migrateProjectName", newJString(migrateProjectName))
  add(path_564288, "resourceGroupName", newJString(resourceGroupName))
  result = call_564287.call(path_564288, query_564289, nil, nil, body_564290)

var migrateProjectsRefreshMigrateProjectSummary* = Call_MigrateProjectsRefreshMigrateProjectSummary_564278(
    name: "migrateProjectsRefreshMigrateProjectSummary",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/refreshSummary",
    validator: validate_MigrateProjectsRefreshMigrateProjectSummary_564279,
    base: "", url: url_MigrateProjectsRefreshMigrateProjectSummary_564280,
    schemes: {Scheme.Https})
type
  Call_MigrateProjectsRegisterTool_564291 = ref object of OpenApiRestCall_563565
proc url_MigrateProjectsRegisterTool_564293(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/registerTool")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsRegisterTool_564292(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564294 = path.getOrDefault("subscriptionId")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "subscriptionId", valid_564294
  var valid_564295 = path.getOrDefault("migrateProjectName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "migrateProjectName", valid_564295
  var valid_564296 = path.getOrDefault("resourceGroupName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "resourceGroupName", valid_564296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564297 = query.getOrDefault("api-version")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564297 != nil:
    section.add "api-version", valid_564297
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564298 = header.getOrDefault("Accept-Language")
  valid_564298 = validateParameter(valid_564298, JString, required = false,
                                 default = nil)
  if valid_564298 != nil:
    section.add "Accept-Language", valid_564298
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Input containing the name of the tool to be registered.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564300: Call_MigrateProjectsRegisterTool_564291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564300.validator(path, query, header, formData, body)
  let scheme = call_564300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564300.url(scheme.get, call_564300.host, call_564300.base,
                         call_564300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564300, url, valid)

proc call*(call_564301: Call_MigrateProjectsRegisterTool_564291; input: JsonNode;
          subscriptionId: string; migrateProjectName: string;
          resourceGroupName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsRegisterTool
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   input: JObject (required)
  ##        : Input containing the name of the tool to be registered.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564302 = newJObject()
  var query_564303 = newJObject()
  var body_564304 = newJObject()
  add(query_564303, "api-version", newJString(apiVersion))
  if input != nil:
    body_564304 = input
  add(path_564302, "subscriptionId", newJString(subscriptionId))
  add(path_564302, "migrateProjectName", newJString(migrateProjectName))
  add(path_564302, "resourceGroupName", newJString(resourceGroupName))
  result = call_564301.call(path_564302, query_564303, nil, nil, body_564304)

var migrateProjectsRegisterTool* = Call_MigrateProjectsRegisterTool_564291(
    name: "migrateProjectsRegisterTool", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/registerTool",
    validator: validate_MigrateProjectsRegisterTool_564292, base: "",
    url: url_MigrateProjectsRegisterTool_564293, schemes: {Scheme.Https})
type
  Call_SolutionsEnumerateSolutions_564305 = ref object of OpenApiRestCall_563565
proc url_SolutionsEnumerateSolutions_564307(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsEnumerateSolutions_564306(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564308 = path.getOrDefault("subscriptionId")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "subscriptionId", valid_564308
  var valid_564309 = path.getOrDefault("migrateProjectName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "migrateProjectName", valid_564309
  var valid_564310 = path.getOrDefault("resourceGroupName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "resourceGroupName", valid_564310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564311 = query.getOrDefault("api-version")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564311 != nil:
    section.add "api-version", valid_564311
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564312: Call_SolutionsEnumerateSolutions_564305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564312.validator(path, query, header, formData, body)
  let scheme = call_564312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564312.url(scheme.get, call_564312.host, call_564312.base,
                         call_564312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564312, url, valid)

proc call*(call_564313: Call_SolutionsEnumerateSolutions_564305;
          subscriptionId: string; migrateProjectName: string;
          resourceGroupName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsEnumerateSolutions
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564314 = newJObject()
  var query_564315 = newJObject()
  add(query_564315, "api-version", newJString(apiVersion))
  add(path_564314, "subscriptionId", newJString(subscriptionId))
  add(path_564314, "migrateProjectName", newJString(migrateProjectName))
  add(path_564314, "resourceGroupName", newJString(resourceGroupName))
  result = call_564313.call(path_564314, query_564315, nil, nil, nil)

var solutionsEnumerateSolutions* = Call_SolutionsEnumerateSolutions_564305(
    name: "solutionsEnumerateSolutions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions",
    validator: validate_SolutionsEnumerateSolutions_564306, base: "",
    url: url_SolutionsEnumerateSolutions_564307, schemes: {Scheme.Https})
type
  Call_SolutionsPutSolution_564328 = ref object of OpenApiRestCall_563565
proc url_SolutionsPutSolution_564330(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsPutSolution_564329(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_564331 = path.getOrDefault("solutionName")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "solutionName", valid_564331
  var valid_564332 = path.getOrDefault("subscriptionId")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "subscriptionId", valid_564332
  var valid_564333 = path.getOrDefault("migrateProjectName")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "migrateProjectName", valid_564333
  var valid_564334 = path.getOrDefault("resourceGroupName")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "resourceGroupName", valid_564334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564335 = query.getOrDefault("api-version")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564335 != nil:
    section.add "api-version", valid_564335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   solutionInput: JObject (required)
  ##                : The input for the solution.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564337: Call_SolutionsPutSolution_564328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564337.validator(path, query, header, formData, body)
  let scheme = call_564337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564337.url(scheme.get, call_564337.host, call_564337.base,
                         call_564337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564337, url, valid)

proc call*(call_564338: Call_SolutionsPutSolution_564328; solutionName: string;
          subscriptionId: string; solutionInput: JsonNode;
          migrateProjectName: string; resourceGroupName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsPutSolution
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   solutionInput: JObject (required)
  ##                : The input for the solution.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564339 = newJObject()
  var query_564340 = newJObject()
  var body_564341 = newJObject()
  add(query_564340, "api-version", newJString(apiVersion))
  add(path_564339, "solutionName", newJString(solutionName))
  add(path_564339, "subscriptionId", newJString(subscriptionId))
  if solutionInput != nil:
    body_564341 = solutionInput
  add(path_564339, "migrateProjectName", newJString(migrateProjectName))
  add(path_564339, "resourceGroupName", newJString(resourceGroupName))
  result = call_564338.call(path_564339, query_564340, nil, nil, body_564341)

var solutionsPutSolution* = Call_SolutionsPutSolution_564328(
    name: "solutionsPutSolution", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}",
    validator: validate_SolutionsPutSolution_564329, base: "",
    url: url_SolutionsPutSolution_564330, schemes: {Scheme.Https})
type
  Call_SolutionsGetSolution_564316 = ref object of OpenApiRestCall_563565
proc url_SolutionsGetSolution_564318(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsGetSolution_564317(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_564319 = path.getOrDefault("solutionName")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "solutionName", valid_564319
  var valid_564320 = path.getOrDefault("subscriptionId")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "subscriptionId", valid_564320
  var valid_564321 = path.getOrDefault("migrateProjectName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "migrateProjectName", valid_564321
  var valid_564322 = path.getOrDefault("resourceGroupName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "resourceGroupName", valid_564322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564323 = query.getOrDefault("api-version")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564323 != nil:
    section.add "api-version", valid_564323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564324: Call_SolutionsGetSolution_564316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564324.validator(path, query, header, formData, body)
  let scheme = call_564324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564324.url(scheme.get, call_564324.host, call_564324.base,
                         call_564324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564324, url, valid)

proc call*(call_564325: Call_SolutionsGetSolution_564316; solutionName: string;
          subscriptionId: string; migrateProjectName: string;
          resourceGroupName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsGetSolution
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564326 = newJObject()
  var query_564327 = newJObject()
  add(query_564327, "api-version", newJString(apiVersion))
  add(path_564326, "solutionName", newJString(solutionName))
  add(path_564326, "subscriptionId", newJString(subscriptionId))
  add(path_564326, "migrateProjectName", newJString(migrateProjectName))
  add(path_564326, "resourceGroupName", newJString(resourceGroupName))
  result = call_564325.call(path_564326, query_564327, nil, nil, nil)

var solutionsGetSolution* = Call_SolutionsGetSolution_564316(
    name: "solutionsGetSolution", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}",
    validator: validate_SolutionsGetSolution_564317, base: "",
    url: url_SolutionsGetSolution_564318, schemes: {Scheme.Https})
type
  Call_SolutionsPatchSolution_564355 = ref object of OpenApiRestCall_563565
proc url_SolutionsPatchSolution_564357(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsPatchSolution_564356(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a solution with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_564358 = path.getOrDefault("solutionName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "solutionName", valid_564358
  var valid_564359 = path.getOrDefault("subscriptionId")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "subscriptionId", valid_564359
  var valid_564360 = path.getOrDefault("migrateProjectName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "migrateProjectName", valid_564360
  var valid_564361 = path.getOrDefault("resourceGroupName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "resourceGroupName", valid_564361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564362 = query.getOrDefault("api-version")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564362 != nil:
    section.add "api-version", valid_564362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   solutionInput: JObject (required)
  ##                : The input for the solution.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564364: Call_SolutionsPatchSolution_564355; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a solution with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  let valid = call_564364.validator(path, query, header, formData, body)
  let scheme = call_564364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564364.url(scheme.get, call_564364.host, call_564364.base,
                         call_564364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564364, url, valid)

proc call*(call_564365: Call_SolutionsPatchSolution_564355; solutionName: string;
          subscriptionId: string; solutionInput: JsonNode;
          migrateProjectName: string; resourceGroupName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsPatchSolution
  ## Update a solution with specified name. Supports partial updates, for example only tags can be provided.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   solutionInput: JObject (required)
  ##                : The input for the solution.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564366 = newJObject()
  var query_564367 = newJObject()
  var body_564368 = newJObject()
  add(query_564367, "api-version", newJString(apiVersion))
  add(path_564366, "solutionName", newJString(solutionName))
  add(path_564366, "subscriptionId", newJString(subscriptionId))
  if solutionInput != nil:
    body_564368 = solutionInput
  add(path_564366, "migrateProjectName", newJString(migrateProjectName))
  add(path_564366, "resourceGroupName", newJString(resourceGroupName))
  result = call_564365.call(path_564366, query_564367, nil, nil, body_564368)

var solutionsPatchSolution* = Call_SolutionsPatchSolution_564355(
    name: "solutionsPatchSolution", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}",
    validator: validate_SolutionsPatchSolution_564356, base: "",
    url: url_SolutionsPatchSolution_564357, schemes: {Scheme.Https})
type
  Call_SolutionsDeleteSolution_564342 = ref object of OpenApiRestCall_563565
proc url_SolutionsDeleteSolution_564344(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsDeleteSolution_564343(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the solution. Deleting non-existent project is a no-operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_564345 = path.getOrDefault("solutionName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "solutionName", valid_564345
  var valid_564346 = path.getOrDefault("subscriptionId")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "subscriptionId", valid_564346
  var valid_564347 = path.getOrDefault("migrateProjectName")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "migrateProjectName", valid_564347
  var valid_564348 = path.getOrDefault("resourceGroupName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "resourceGroupName", valid_564348
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564349 = query.getOrDefault("api-version")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564349 != nil:
    section.add "api-version", valid_564349
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564350 = header.getOrDefault("Accept-Language")
  valid_564350 = validateParameter(valid_564350, JString, required = false,
                                 default = nil)
  if valid_564350 != nil:
    section.add "Accept-Language", valid_564350
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564351: Call_SolutionsDeleteSolution_564342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the solution. Deleting non-existent project is a no-operation.
  ## 
  let valid = call_564351.validator(path, query, header, formData, body)
  let scheme = call_564351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564351.url(scheme.get, call_564351.host, call_564351.base,
                         call_564351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564351, url, valid)

proc call*(call_564352: Call_SolutionsDeleteSolution_564342; solutionName: string;
          subscriptionId: string; migrateProjectName: string;
          resourceGroupName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsDeleteSolution
  ## Delete the solution. Deleting non-existent project is a no-operation.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564353 = newJObject()
  var query_564354 = newJObject()
  add(query_564354, "api-version", newJString(apiVersion))
  add(path_564353, "solutionName", newJString(solutionName))
  add(path_564353, "subscriptionId", newJString(subscriptionId))
  add(path_564353, "migrateProjectName", newJString(migrateProjectName))
  add(path_564353, "resourceGroupName", newJString(resourceGroupName))
  result = call_564352.call(path_564353, query_564354, nil, nil, nil)

var solutionsDeleteSolution* = Call_SolutionsDeleteSolution_564342(
    name: "solutionsDeleteSolution", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}",
    validator: validate_SolutionsDeleteSolution_564343, base: "",
    url: url_SolutionsDeleteSolution_564344, schemes: {Scheme.Https})
type
  Call_SolutionsCleanupSolutionData_564369 = ref object of OpenApiRestCall_563565
proc url_SolutionsCleanupSolutionData_564371(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName"),
               (kind: ConstantSegment, value: "/cleanupData")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsCleanupSolutionData_564370(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_564372 = path.getOrDefault("solutionName")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "solutionName", valid_564372
  var valid_564373 = path.getOrDefault("subscriptionId")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "subscriptionId", valid_564373
  var valid_564374 = path.getOrDefault("migrateProjectName")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "migrateProjectName", valid_564374
  var valid_564375 = path.getOrDefault("resourceGroupName")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "resourceGroupName", valid_564375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564376 = query.getOrDefault("api-version")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564376 != nil:
    section.add "api-version", valid_564376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564377: Call_SolutionsCleanupSolutionData_564369; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564377.validator(path, query, header, formData, body)
  let scheme = call_564377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564377.url(scheme.get, call_564377.host, call_564377.base,
                         call_564377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564377, url, valid)

proc call*(call_564378: Call_SolutionsCleanupSolutionData_564369;
          solutionName: string; subscriptionId: string; migrateProjectName: string;
          resourceGroupName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsCleanupSolutionData
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564379 = newJObject()
  var query_564380 = newJObject()
  add(query_564380, "api-version", newJString(apiVersion))
  add(path_564379, "solutionName", newJString(solutionName))
  add(path_564379, "subscriptionId", newJString(subscriptionId))
  add(path_564379, "migrateProjectName", newJString(migrateProjectName))
  add(path_564379, "resourceGroupName", newJString(resourceGroupName))
  result = call_564378.call(path_564379, query_564380, nil, nil, nil)

var solutionsCleanupSolutionData* = Call_SolutionsCleanupSolutionData_564369(
    name: "solutionsCleanupSolutionData", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}/cleanupData",
    validator: validate_SolutionsCleanupSolutionData_564370, base: "",
    url: url_SolutionsCleanupSolutionData_564371, schemes: {Scheme.Https})
type
  Call_SolutionsGetConfig_564381 = ref object of OpenApiRestCall_563565
proc url_SolutionsGetConfig_564383(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName"),
               (kind: ConstantSegment, value: "/getConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsGetConfig_564382(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_564384 = path.getOrDefault("solutionName")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "solutionName", valid_564384
  var valid_564385 = path.getOrDefault("subscriptionId")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "subscriptionId", valid_564385
  var valid_564386 = path.getOrDefault("migrateProjectName")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "migrateProjectName", valid_564386
  var valid_564387 = path.getOrDefault("resourceGroupName")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "resourceGroupName", valid_564387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564388 = query.getOrDefault("api-version")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564388 != nil:
    section.add "api-version", valid_564388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564389: Call_SolutionsGetConfig_564381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564389.validator(path, query, header, formData, body)
  let scheme = call_564389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564389.url(scheme.get, call_564389.host, call_564389.base,
                         call_564389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564389, url, valid)

proc call*(call_564390: Call_SolutionsGetConfig_564381; solutionName: string;
          subscriptionId: string; migrateProjectName: string;
          resourceGroupName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsGetConfig
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  var path_564391 = newJObject()
  var query_564392 = newJObject()
  add(query_564392, "api-version", newJString(apiVersion))
  add(path_564391, "solutionName", newJString(solutionName))
  add(path_564391, "subscriptionId", newJString(subscriptionId))
  add(path_564391, "migrateProjectName", newJString(migrateProjectName))
  add(path_564391, "resourceGroupName", newJString(resourceGroupName))
  result = call_564390.call(path_564391, query_564392, nil, nil, nil)

var solutionsGetConfig* = Call_SolutionsGetConfig_564381(
    name: "solutionsGetConfig", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}/getConfig",
    validator: validate_SolutionsGetConfig_564382, base: "",
    url: url_SolutionsGetConfig_564383, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
